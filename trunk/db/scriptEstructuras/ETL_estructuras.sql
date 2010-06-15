--CREATEDB hidro_etl_execution


DROP TABLE if exists batches;
DROP TABLE if exists jobs;
DROP TABLE if exists records;
DROP TABLE if exists schema_info;


CREATE TABLE batches
(
  id serial NOT NULL,
  batch_file varchar(255) NOT NULL,
  created_at timestamp NOT NULL,
  completed_at timestamp,
  status varchar(255),
  CONSTRAINT batches_pkey PRIMARY KEY (id)
) 
;



CREATE TABLE jobs
(
  id serial NOT NULL,
  control_file varchar(255) NOT NULL,
  created_at timestamp NOT NULL,
  completed_at timestamp,
  status varchar(255),
  batch_id int4,
  CONSTRAINT jobs_pkey PRIMARY KEY (id)
) 
;


CREATE TABLE records
(
  id serial NOT NULL,
  control_file varchar(255) NOT NULL,
  natural_key varchar(255) NOT NULL,
  crc varchar(255) NOT NULL,
  job_id int4 NOT NULL,
  CONSTRAINT records_pkey PRIMARY KEY (id)
) 
;


CREATE TABLE schema_info
(
  version int4
) 
;


