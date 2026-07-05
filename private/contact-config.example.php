<?php
/**
 * VOORBEELDCONFIGURATIE — kopieer naar contact-config.php en vul in.
 *
 * Plaats het echte bestand BUITEN de webroot, bijvoorbeeld:
 *   /domains/secbv.nl/private/contact-config.php
 *
 * Dit .example-bestand bevat GEEN echte gegevens en mag in git staan.
 * Het echte contact-config.php staat in .gitignore.
 */

return [
    // SMTP-server (Vimexx / DirectAdmin)
    'smtp_host'      => 'mail.secbv.nl',
    'smtp_port'      => 465,          // SMTPS
    'smtp_user'      => 'website@secbv.nl',
    'smtp_password'  => 'VUL_HIER_HET_WACHTWOORD_IN',

    // Vast afzenderadres (moet het geauthenticeerde account zijn i.v.m. SPF/DKIM)
    'from_email'     => 'website@secbv.nl',
    'from_name'      => 'Website S.E.C. B.V.',

    // Ontvanger van de contactberichten
    'recipient'      => 'info@secbv.nl',
    'recipient_name' => 'S.E.C. B.V.',

    // Blinde kopie (BCC) — laat leeg ('') om uit te schakelen
    'bcc'            => 'info@rickswebsites.nl',

    // Schrijfbare map voor rate-limiting-bestanden.
    // Laat leeg ('') om de systeem-temp-map te gebruiken.
    'storage_dir'    => '',
];
