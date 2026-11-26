# Privacy and Data Protection

Fetosense handles sensitive health data about pregnant women and their babies: names, contact details, pregnancy dates and fetal monitoring (CTG) recordings. This document explains who is responsible for that data and what you must do before deploying Fetosense with real patients.

> **Not legal advice.** This guide summarises common obligations. Confirm the requirements in your jurisdiction with a qualified lawyer before going live.

## Who is responsible for the data

Responsibility follows control. Whoever decides why and how patient data is processed is the **Data Fiduciary** (India, DPDPA) or **Controller** (GDPR).

| Deployment | Who is responsible | Which privacy policy applies |
| --- | --- | --- |
| You self-host Fetosense from this repository | **You**, the deploying organisation | Your own privacy notice |
| A hospital uses Fetosense operated by CareNX | The hospital is the Data Fiduciary; CareNX is its Data Processor under contract | Hospital's notice plus the [CareNX Privacy Policy](https://carenx.com/privacy-policy) |
| You use a CareNX service directly | CareNX | [CareNX Privacy Policy](https://carenx.com/privacy-policy) |

CareNX receives no data from self-hosted deployments, as long as you point the apps at your own backend (see step 2 below). The software is provided under the MIT License, "as is", without warranty.

## What personal data Fetosense processes

| Repository | Used by | Personal data handled | Stored in |
| --- | --- | --- | --- |
| [fetosense_device_flutter](https://github.com/CareNX-Innovations-Pvt-Ltd/fetosense_device_flutter) | Health workers, on an Android tablet connected to the Fetosense Doppler | Mother: name, age, mobile number, email, LMP, EDD. Test: fetal heart rate, uterine activity (TOCO), fetal movement, maternal heart rate and SpO₂, gestational age, weight, interpretation. Doctor and organisation names, device ID | Appwrite backend; app preferences and generated PDF reports on the tablet |
| [fetosense_remote_flutter](https://github.com/CareNX-Innovations-Pvt-Ltd/fetosense_remote_flutter) | Doctors, on Android or iOS | Reads mothers and tests; the doctor's own account details; interpretations | Appwrite backend; notifications on the phone |
| [fetosense-web-flutter](https://github.com/CareNX-Innovations-Pvt-Ltd/fetosense-web-flutter) | Hospital administrators, in a browser | Mothers, tests, devices and users; Excel exports | Appwrite backend; exported files on the user's computer |

All three apps share one [Appwrite](https://appwrite.io) backend. Appwrite is open source and self-hostable, so you decide where the data lives.

## Before you go live

1. **Run your own backend.** Self-host Appwrite in a location that meets your data-residency rules. Serve it over HTTPS only, encrypt the database and storage disks, and set up backups.
2. **Point every app at your backend.** Set `appwriteEndpoint` (an `https://` URL) and `appwriteProjectId` in:
    - device app: `lib/core/constants/app_constants.dart`
    - remote app: `lib/core/utils/app_constants.dart`
    - web dashboard: `lib/core/utils/app_constants.dart`

    A build left pointing at CareNX's servers would send your patients' data to CareNX. Check this before every release.
3. **Replace the privacy-policy links** with your own: the remote app's `launchPrivacy()` in `lib/ui/views/profile_view.dart`, and the device app's About screen.
4. **Publish a privacy notice and get consent** before registering a patient. Under India's DPDP Rules, the notice must itemise the data collected and its purposes, and explain how to withdraw consent, exercise rights and complain to the Data Protection Board.
5. **Appoint a Grievance Officer** (India) or Data Protection Officer where required, and publish their contact details.
6. **Restrict access.** Use the web dashboard's roles, and set Appwrite collection and document permissions so staff see only their own organisation's patients.
7. **Set retention and deletion rules.** Records deleted in the apps are only flagged (`delete: true`), not erased. To erase a record, delete the document and its files in Appwrite (console or API).
8. **Handle rights requests.** Use the web dashboard's Excel export and the PDF reports to give patients their data; correct or erase records in Appwrite.
9. **Prepare a breach-response plan** that meets your notification deadlines (see the table below).
10. **Plan for patients under 18.** Adolescent pregnancies are common; check the parental-consent rules and healthcare exemptions in your jurisdiction.
11. **Sign data-processing agreements** with your hosting and other service providers.
12. **Clinical use needs regulatory clearance.** Open-source availability is not medical-device approval. Any clinical deployment must meet your local medical-device regulations.

## Laws to check

| Jurisdiction | Main laws | Notes |
| --- | --- | --- |
| India | Digital Personal Data Protection Act, 2023 and DPDP Rules, 2025 | Notice, consent, rights, breach and grievance obligations apply from 13 May 2027 |
| India | Information Technology Act, 2000 and SPDI Rules, 2011 | Apply until the DPDPA fully replaces them; health data is "sensitive personal data"; a Grievance Officer is required |
| India | CERT-In Directions, 2022 | Report cyber security incidents within 6 hours |
| European Union / EEA | General Data Protection Regulation (GDPR) | Health data is special-category data; breach notification within 72 hours |
| Elsewhere | Local data-protection, health-records and medical-device laws | For example HIPAA in the United States |

## Privacy features and known limitations

**Available now**

- Self-hostable backend, so data stays where you choose
- Role-based access in the web dashboard
- Excel export of patient records and PDF CTG reports

**Not yet available** (as of 26th November, 2026)

- A consent step at patient registration that records consent and supports withdrawal
- Permanent erasure of patient records from within the apps (soft delete only today)
- Backend address and policy link set through a config file rather than in source code

## For contributors

- **Never commit real patient data** to this repository, including issues, pull requests, screenshots, logs and test fixtures. Use synthetic or fully de-identified data.
- **Never log credentials or patient data**, including in debug output.
- **Never commit secrets.** API keys, passwords, backend URLs and project IDs belong in local configuration, not in source code.

## Reporting a privacy or security issue

Please do not open a public issue. Email [grievance@carenx.com](mailto:grievance@carenx.com) with a description and steps to reproduce. We aim to acknowledge reports within 2 working days.

If you find personal data in this repository, report it the same way so it can be removed from the repository's history.
