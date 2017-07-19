function conn = connectPostgreSQL(username,passwd,dbname)

db.driver='D:\GitHub\DenHaagTransitResearch\dbconnection\postgresql-9.3-1101.jdbc4.jar';
db.driverpath='/';
db.driverpath=strcat(db.driverpath,db.driver);
javaclasspath(db.driverpath);
db.username = username;
db.passwd = passwd;
db.dbname = dbname;
db.conurl = ['jdbc:postgresql://localhost:5432/' db.dbname];
% connection
conn = database(db.dbname,db.username,db.passwd,'org.postgresql.Driver', db.conurl);
fprintf('database %s connected...\n',db.dbname);

end