#!/bin/sh

mkdir -p /run/mysqld && mkdir -p /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql


if [ ! -d /var/lib/mysql/mysql ]; then
    if mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null; then
		echo "[i] MySQL database successfully installed."
	else
		exit 1
    fi
fi

cat << EOF > tmpfile
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;

EOF

/usr/bin/mysqld --user=mysql --bootstrap --skip-name-resolve --skip-networking=0 < tmpfile

rm -f tmpfile

exec /usr/bin/mysqld --user=mysql --skip-name-resolve --skip-networking=0 $@

# connect to MySQL as the root user: mysql -u root -p (then enter the root password).
# Show the list of databases: SHOW DATABASES;
# Use the 'wordpress' database: use 'wordpress';
# Show the tables in the selected database: SHOW TABLES;
# Select the display name of users from the 'wp_users' table: SELECT wp_users.display_name FROM wp_users;
# Select all columns from the 'wp_users' table: SELECT * FROM wp_users;