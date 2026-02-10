<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpressdb' );

/** MySQL database username */
define( 'DB_USER', 'myuser' );

/** MySQL database password */
define( 'DB_PASSWORD', 'mypass' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '6hNX 9U&g~P8R[5!t,r0;j%FrM^r~=B{GJ~{~=q){yE-N)|4>q?]]w4n~1)QGKmu');
define('SECURE_AUTH_KEY',  'M>QeY-xQVV0t6J{|.k Rn+.d1=g9jngqMb}` U3|vK#8G=~2RXu!uG|f+ik[|XKM');
define('LOGGED_IN_KEY',    'P%!nnAS%_bG_=2,<jMDO.kFBe+_v<p$VTY{KQ:@p}rU]P|dirE;$7<39L0-XOp|x');
define('NONCE_KEY',        'i-e$tpmIccjxkxk|1/3T)O}Azk#;uO2$?%-b6-&IIo2#,:E8> DJe.Z?<T>RL!_W');
define('AUTH_SALT',        '&yAC>H:wV0Y9}[Lhk~ZNP4lj[9S DVdWdyjw>iLGLp)| P5{(do^scQ*@_4}At*8');
define('SECURE_AUTH_SALT', ';R8aEHmw__a_0#~Ebold1<6N?ys,%K#NJFKS.w-6mMSph_uf+0p)=w)*GyYq.%f+');
define('LOGGED_IN_SALT',   '<-hnM+2L1aV_jOdYnMfs{aK6N(l-4(p.4o)Z,b+=0T$sdX?-@n!->]bRooUk$o+m');
define('NONCE_SALT',       '()NOs`o+Ja.;)5&EAZo-Ey?-Q|;eR/(u]$%aa.iVman>*1a0Zptw+t-1d1fy_|.U');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';