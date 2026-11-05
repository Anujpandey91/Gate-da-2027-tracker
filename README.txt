GATE DA 2027 Study Workspace — Cloud-enabled build

1. In Supabase, open SQL Editor → New query.
2. Paste and run the contents of supabase-setup.sql.
3. In Authentication → URL Configuration, add the deployed website URL to Site URL and Redirect URLs.
4. Deploy this folder to a static host (GitHub Pages, Netlify, or Vercel).
5. Open the website and use “Sign in / Create account”. Supabase sends a passwordless email link.
6. After sign-in, the site loads your cloud workspace and automatically syncs future edits.

Security:
- The frontend contains only the Supabase publishable key.
- The table has Row Level Security and each user can access only their own row.
- Never put a Supabase secret/service_role key in this website.

Existing local progress:
- Export a JSON backup from the old website before switching to a different hosting origin.
- After sign-in on the new website, use Import backup to load that JSON. It will be saved locally and synced to your account.
- If the old and new site URLs differ, browser localStorage does not transfer between them automatically.

The site still works locally if cloud sync is unavailable, and keeps localStorage as a fallback.
