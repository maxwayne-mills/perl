<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'test.opensitesolutions.com');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', '');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'D)#Y}P:tMN25-DEHL&<p4ie=VjZZSW5AVG?o8wbGk|/Q!x_]mW-N;<k# ,-2w.-;');
define('SECURE_AUTH_KEY',  'Cx59wTmc3MCiHinaSSFrhmYm=-DU2&+]XS[tyU1T)hX8q<b@^r)-OI_b[HgQMWG`');
define('LOGGED_IN_KEY',    'TIhS_lVIXI(%4A%U@Rr r5[?&hmc(/4f &g+NO+D)v8xO~2SIoX4?(rQ9TQ3#$H=');
define('NONCE_KEY',        '^P,|HNN4O09O*k$9k&}3mMI*3]zTr[n1]+Mt1p8%`+/%q-w&v^m|Y[NdFT}NZcQ-');
define('AUTH_SALT',        '-_og}5;S=hAfj|BwrMj6CdXG&{*fAoVC6BfD,SnxUm2PgO#TS(H_-Oq_F+hRH4L&');
define('SECURE_AUTH_SALT', '}2<XnJPko>8_byBSU;.!B@~A-Ev-;6+^!f%5=LNd3U_xakaa8Tb`t2FI)6+]IUcI');
define('LOGGED_IN_SALT',   'oXbN.*TA%L&lY(gjyJTf2FLu1BcepVbBjorPY&:39_eqeT4H,+pU%McixV^L_9$y');
define('NONCE_SALT',       'L7Gje|MQBF<iaT->MU7SKC6Qm~[_Co;{;n-F_t1Rb89ShjGN29AD1NJla(L{%AHv');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'opensitesolutions';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

