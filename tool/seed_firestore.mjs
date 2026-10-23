// Uploads tool/seed/catalog.json to Firestore (collections `products` and
// `banners`). Idempotent: running it again overwrites the same documents.
//
// Usage (from the project root):
//   cd tool && npm install
//   GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json \
//     node seed_firestore.mjs [projectId]
//
// To fill the local emulator instead (see README):
//   FIRESTORE_EMULATOR_HOST=localhost:8080 node seed_firestore.mjs
//
// Get the key in Firebase console -> Project settings -> Service accounts ->
// "Generate new private key". Never commit that file.
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const projectId = process.argv[2] ?? 'furniture-store-bekzod';
const here = dirname(fileURLToPath(import.meta.url));
const catalog = JSON.parse(readFileSync(join(here, 'seed', 'catalog.json'), 'utf8'));

// Against the local emulator (FIRESTORE_EMULATOR_HOST is set) no credentials
// are needed.
const useEmulator = Boolean(process.env.FIRESTORE_EMULATOR_HOST);
initializeApp(
  useEmulator ? { projectId } : { credential: applicationDefault(), projectId },
);
const db = getFirestore();

async function upload(collection, docs) {
  const batch = db.batch();
  for (const { id, ...data } of docs) {
    batch.set(db.collection(collection).doc(id), data);
  }
  await batch.commit();
  console.log(`${collection}: ${docs.length} documents`);
}

await upload('products', catalog.products);
await upload('banners', catalog.banners);
console.log(`Done. Project: ${projectId}`);
