-- Generated by Ora2Pg, the Oracle database Schema converter, version 21.1
-- Copyright 2000-2020 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:INT8R

SET client_encoding TO 'UTF8';

\set ON_ERROR_STOP ON

SET check_function_bodies = false;

CREATE SCHEMA IF NOT EXISTS doma_pandabigmon;
ALTER SCHEMA doma_pandabigmon OWNER TO panda;

SET search_path = doma_pandabigmon,public;

CREATE TABLE all_requests (
	id bigint,
	server varchar(40),
	remote varchar(100),
	qtime timestamp,
	url varchar(2500),
	referrer varchar(4000),
	useragent varchar(400),
	is_rejected smallint,
	urlview varchar(300)
) ;
ALTER TABLE all_requests OWNER TO panda;
CREATE INDEX all_requests_urlview_qtime_idx ON all_requests (urlview, qtime);

CREATE TABLE all_requests_daily (
	qtime timestamp,
	remote varchar(100),
	is_rejected smallint,
	server varchar(40),
	urlview varchar(300),
	url varchar(2500),
	referrer varchar(4000),
	useragent varchar(400),
	rtime timestamp,
	load decimal(10,2),
	mem decimal(10,2),
	dbactivesess integer,
	dbtotalsess integer,
	id bigint
) ;
ALTER TABLE all_requests_daily OWNER TO panda;

CREATE TABLE atlas_jobs_buster_ansess (
	session_id bigint GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1 MAXVALUE 9223372036854775807 MINVALUE 1 NO CYCLE CACHE 20 ),
	timewindow_start timestamp,
	timewindow_end timestamp,
	analysis_started timestamp,
	analysis_finished timestamp
) ;
ALTER TABLE atlas_jobs_buster_ansess OWNER TO panda;
CREATE INDEX timewindow_end_idx ON atlas_jobs_buster_ansess (timewindow_end desc);
ALTER TABLE atlas_jobs_buster_ansess ADD PRIMARY KEY (session_id);

CREATE TABLE atlas_jobs_buster_issue (
	issue_id bigint GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1 MAXVALUE 9223372036854775807 MINVALUE 1 NO CYCLE CACHE 20 ),
	observation_started timestamp NOT NULL,
	observation_finished timestamp NOT NULL,
	walltime_loss bigint,
	nfailed_jobs bigint,
	nsuccess_jobs bigint,
	session_id_fk bigint,
	payload_type numeric(38),
	err_messages text
) ;
ALTER TABLE atlas_jobs_buster_issue OWNER TO panda;
CREATE INDEX issue_start ON atlas_jobs_buster_issue (observation_started desc, observation_finished desc);
ALTER TABLE atlas_jobs_buster_issue ADD PRIMARY KEY (issue_id);

CREATE TABLE atlas_jobs_buster_issue_meta (
	meta_id bigint GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1 MAXVALUE 9223372036854775807 MINVALUE 1 NO CYCLE CACHE 20 ),
	issue_id_fk bigint,
	key varchar(512),
	value varchar(512)
) ;
ALTER TABLE atlas_jobs_buster_issue_meta OWNER TO panda;
CREATE INDEX atlas_jobs_buster_issue_meta_iss_ind ON atlas_jobs_buster_issue_meta (issue_id_fk desc);

CREATE TABLE atlas_jobs_buster_issue_ticks (
	tick_id bigint GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1 MAXVALUE 9223372036854775807 MINVALUE 1 NO CYCLE CACHE 20 ),
	issue_id_fk bigint,
	tick_time timestamp,
	walltime_loss bigint,
	nfailed_jobs bigint
) ;
ALTER TABLE atlas_jobs_buster_issue_ticks OWNER TO panda;
CREATE INDEX ind_issue_is ON atlas_jobs_buster_issue_ticks (issue_id_fk);

CREATE TABLE auth_group (
	id bigint NOT NULL,
	name varchar(80)
) ;
ALTER TABLE auth_group OWNER TO panda;
ALTER TABLE auth_group ADD UNIQUE (name);
ALTER TABLE auth_group ADD PRIMARY KEY (id);

CREATE TABLE auth_group_permissions (
	id bigint NOT NULL,
	group_id bigint NOT NULL,
	permission_id bigint NOT NULL
) ;
ALTER TABLE auth_group_permissions OWNER TO panda;
CREATE INDEX auth_group_group_id_b120cbf9 ON auth_group_permissions (group_id);
CREATE INDEX auth_group_permission_84c5c92e ON auth_group_permissions (permission_id);
ALTER TABLE auth_group_permissions ADD UNIQUE (group_id,permission_id);
ALTER TABLE auth_group_permissions ADD PRIMARY KEY (id);

CREATE TABLE auth_permission (
	id bigint NOT NULL,
	name varchar(255),
	content_type_id bigint NOT NULL,
	codename varchar(100)
) ;
ALTER TABLE auth_permission OWNER TO panda;
CREATE INDEX auth_permi_content_ty_2f476e4b ON auth_permission (content_type_id);
ALTER TABLE auth_permission ADD UNIQUE (content_type_id,codename);
ALTER TABLE auth_permission ADD PRIMARY KEY (id);

CREATE TABLE auth_user (
	id bigint NOT NULL,
	password varchar(128),
	last_login timestamp,
	is_superuser smallint NOT NULL,
	username varchar(150),
	first_name varchar(30),
	last_name varchar(30),
	email varchar(254),
	is_staff smallint NOT NULL,
	is_active smallint NOT NULL,
	date_joined timestamp NOT NULL,
	is_tester smallint
) ;
ALTER TABLE auth_user OWNER TO panda;
ALTER TABLE auth_user ADD PRIMARY KEY (id);
ALTER TABLE auth_user ADD UNIQUE (username);
ALTER TABLE auth_user ADD CONSTRAINT sys_c0013273686 CHECK (is_active IN (0,1));
ALTER TABLE auth_user ADD CONSTRAINT sys_c0013273684 CHECK (is_superuser IN (0,1));
ALTER TABLE auth_user ADD CONSTRAINT sys_c0013273685 CHECK (is_staff IN (0,1));

CREATE TABLE auth_user_groups (
	id bigint NOT NULL,
	user_id bigint NOT NULL,
	group_id bigint NOT NULL
) ;
ALTER TABLE auth_user_groups OWNER TO panda;
CREATE INDEX auth_user__group_id_97559544 ON auth_user_groups (group_id);
CREATE INDEX auth_user__user_id_6a12ed8b ON auth_user_groups (user_id);
ALTER TABLE auth_user_groups ADD PRIMARY KEY (id);
ALTER TABLE auth_user_groups ADD UNIQUE (user_id,group_id);

CREATE TABLE auth_user_user_permissions (
	id bigint NOT NULL,
	user_id bigint NOT NULL,
	permission_id bigint NOT NULL
) ;
ALTER TABLE auth_user_user_permissions OWNER TO panda;
CREATE INDEX auth_user__permission_1fbb5f2c ON auth_user_user_permissions (permission_id);
CREATE INDEX auth_user__user_id_a95ead1b ON auth_user_user_permissions (user_id);
ALTER TABLE auth_user_user_permissions ADD PRIMARY KEY (id);
ALTER TABLE auth_user_user_permissions ADD UNIQUE (user_id,permission_id);

CREATE TABLE djangocache (
	cache_key varchar(1000) NOT NULL,
	expires timestamp NOT NULL,
	value text NOT NULL
) ;
ALTER TABLE djangocache OWNER TO panda;
CREATE INDEX djangocache_indx_expires ON djangocache (expires);
ALTER TABLE djangocache ADD PRIMARY KEY (cache_key);

CREATE TABLE django_admin_log (
	id bigint NOT NULL,
	action_time timestamp NOT NULL,
	object_id text,
	object_repr varchar(200),
	action_flag bigint NOT NULL,
	change_message text,
	content_type_id bigint,
	user_id bigint NOT NULL
) ;
ALTER TABLE django_admin_log OWNER TO panda;
CREATE INDEX django_adm_content_ty_c4bce8eb ON django_admin_log (content_type_id);
CREATE INDEX django_adm_user_id_c564eba6 ON django_admin_log (user_id);
ALTER TABLE django_admin_log ADD PRIMARY KEY (id);
ALTER TABLE django_admin_log ADD CONSTRAINT sys_c0013273712 CHECK (action_flag >= 0);

CREATE TABLE django_content_type (
	id bigint NOT NULL,
	app_label varchar(100),
	model varchar(100)
) ;
ALTER TABLE django_content_type OWNER TO panda;
ALTER TABLE django_content_type ADD PRIMARY KEY (id);
ALTER TABLE django_content_type ADD UNIQUE (app_label,model);

CREATE TABLE django_migrations (
	id bigint NOT NULL,
	app varchar(255),
	name varchar(255),
	applied timestamp NOT NULL
) ;
ALTER TABLE django_migrations OWNER TO panda;
ALTER TABLE django_migrations ADD PRIMARY KEY (id);

CREATE TABLE django_session (
	session_key varchar(40) NOT NULL,
	session_data text,
	expire_date timestamp NOT NULL
) ;
ALTER TABLE django_session OWNER TO panda;
CREATE INDEX django_ses_expire_dat_a5c62663 ON django_session (expire_date);
ALTER TABLE django_session ADD PRIMARY KEY (session_key);

CREATE TABLE jobspage_cumulative_result (
	request_token bigint NOT NULL,
	attr varchar(50) NOT NULL,
	attr_value varchar(500) NOT NULL,
	num_occur bigint,
	num_iterations smallint,
	token_insert_tstamp timestamp DEFAULT LOCALTIMESTAMP
) ;
COMMENT ON TABLE jobspage_cumulative_result IS E'Table for hosting cumulative result when processing the data with the ATLAS_PANDABIGMON.QUERY_JOBSPAGE_ARCH_PARTITION function.';
ALTER TABLE jobspage_cumulative_result OWNER TO panda;
ALTER TABLE jobspage_cumulative_result ADD PRIMARY KEY (request_token,attr,attr_value);

CREATE TABLE monitor_users (
	id bigint NOT NULL,
	dname varchar(200) NOT NULL,
	username varchar(200),
	firstlogindate timestamp DEFAULT (CAST((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') AS timestamp)),
	isactive smallint DEFAULT 1,
	email varchar(100)
) ;
ALTER TABLE monitor_users OWNER TO panda;
ALTER TABLE monitor_users ADD PRIMARY KEY (id);

CREATE TABLE old_pandamon_jobspage_aggr (
	modifdate timestamp,
	attr varchar(50),
	attr_value varchar(500),
	num_occur bigint,
	computed_on timestamp DEFAULT LOCALTIMESTAMP
) PARTITION BY RANGE (modifdate) ;
ALTER TABLE old_pandamon_jobspage_aggr OWNER TO panda;

CREATE TABLE old_pandamon_jobspage_all (
	part_id bigint,
	data_snapshot_at timestamp,
	pandaid bigint,
	retrial char(1),
	modificationtime timestamp,
	atlasrelease varchar(64),
	attemptnr smallint,
	computingsite varchar(128),
	cloud varchar(50),
	eventservice smallint,
	homepackage varchar(80),
	inputfileproject varchar(64),
	inputfiletype varchar(32),
	jeditaskid bigint,
	jobstatus varchar(15),
	jobsubstatus varchar(80),
	minramcount bigint,
	nucleus varchar(52),
	processingtype varchar(64),
	prodsourcelabel varchar(20),
	produsername varchar(60),
	reqid integer,
	transformation varchar(250),
	workinggroup varchar(20)
) PARTITION BY RANGE (part_id) ;
ALTER TABLE old_pandamon_jobspage_all OWNER TO panda;

CREATE TABLE pandamon_jobspage (
	part_id bigint,
	data_snapshot_at timestamp,
	pandaid bigint,
	retrial char(1),
	modificationtime timestamp,
	atlasrelease varchar(64),
	attemptnr smallint,
	computingsite varchar(128),
	cloud varchar(50),
	eventservice smallint,
	homepackage varchar(80),
	inputfileproject varchar(64),
	inputfiletype varchar(32),
	jeditaskid bigint,
	jobstatus varchar(15),
	jobsubstatus varchar(80),
	minramcount bigint,
	nucleus varchar(52),
	processingtype varchar(64),
	prodsourcelabel varchar(20),
	produsername varchar(60),
	reqid integer,
	transformation varchar(250),
	workinggroup varchar(20),
	brokerageerrorcode varchar(7),
	ddmerrorcode varchar(7),
	exeerrorcode varchar(7),
	jobdispatchererrorcode varchar(7),
	piloterrorcode varchar(7),
	superrorcode varchar(7),
	taskbuffererrorcode varchar(7),
	transexitcode varchar(7),
	actualcorecount integer,
	corecount smallint,
	jobsetid bigint,
	nevents bigint,
	specialhandling varchar(80),
	maxpss bigint,
	jobduration bigint,
	esevents_ready bigint,
	esevents_sent bigint,
	esevents_running bigint,
	esevents_finished bigint,
	esevents_cancelled bigint,
	esevents_discarded bigint,
	esevents_done bigint,
	esevents_failed bigint,
	esevents_fatal bigint,
	esevents_merged bigint,
	dupl_with_arch smallint,
	gshare varchar(40),
	priorityrange varchar(20)
) PARTITION BY RANGE (part_id) ;
COMMENT ON COLUMN pandamon_jobspage.dupl_with_arch IS E'A "flag" column for marking whether the PanDA job record exists as well into the PANDAMON_JOBSPAGE_ARCH table.';
ALTER TABLE pandamon_jobspage OWNER TO panda;

CREATE TABLE pandamon_jobspage_arch (
	modificationtime timestamp,
	pandaid bigint,
	retrial char(1),
	atlasrelease varchar(64),
	attemptnr smallint,
	computingsite varchar(128),
	cloud varchar(50),
	eventservice smallint,
	homepackage varchar(80),
	inputfileproject varchar(64),
	inputfiletype varchar(32),
	jeditaskid bigint,
	jobstatus varchar(15),
	jobsubstatus varchar(80),
	minramcount bigint,
	nucleus varchar(52),
	processingtype varchar(64),
	prodsourcelabel varchar(20),
	produsername varchar(60),
	reqid integer,
	transformation varchar(250),
	workinggroup varchar(20),
	brokerageerrorcode varchar(7),
	ddmerrorcode varchar(7),
	exeerrorcode varchar(7),
	jobdispatchererrorcode varchar(7),
	piloterrorcode varchar(7),
	superrorcode varchar(7),
	taskbuffererrorcode varchar(7),
	transexitcode varchar(7),
	actualcorecount integer,
	corecount smallint,
	jobsetid bigint,
	nevents bigint,
	specialhandling varchar(80),
	maxpss bigint,
	jobduration bigint,
	esevents_ready bigint,
	esevents_sent bigint,
	esevents_running bigint,
	esevents_finished bigint,
	esevents_cancelled bigint,
	esevents_discarded bigint,
	esevents_done bigint,
	esevents_failed bigint,
	esevents_fatal bigint,
	esevents_merged bigint,
	priorityrange varchar(20),
	gshare varchar(40)
) PARTITION BY RANGE (modificationtime) ;
ALTER TABLE pandamon_jobspage_arch OWNER TO panda;
CREATE INDEX jobspage_arch_inputfilepr_idx ON pandamon_jobspage_arch (inputfileproject, modificationtime);
CREATE INDEX jobspage_arch_jeditaskid_idx ON pandamon_jobspage_arch (jeditaskid, modificationtime);

CREATE TABLE pandamon_jobspage_arch_new (
	modificationtime timestamp,
	pandaid bigint,
	retrial char(1),
	atlasrelease varchar(64),
	attemptnr smallint,
	computingsite varchar(128),
	cloud varchar(50),
	eventservice smallint,
	homepackage varchar(80),
	inputfileproject varchar(64),
	inputfiletype varchar(32),
	jeditaskid bigint,
	jobstatus varchar(15),
	jobsubstatus varchar(80),
	minramcount bigint,
	nucleus varchar(52),
	processingtype varchar(64),
	prodsourcelabel varchar(20),
	produsername varchar(60),
	reqid integer,
	transformation varchar(250),
	workinggroup varchar(20),
	brokerageerrorcode varchar(7),
	ddmerrorcode varchar(7),
	exeerrorcode varchar(7),
	jobdispatchererrorcode varchar(7),
	piloterrorcode varchar(7),
	superrorcode varchar(7),
	taskbuffererrorcode varchar(7),
	transexitcode varchar(7),
	actualcorecount integer DEFAULT 0,
	corecount smallint DEFAULT 1,
	jobsetid bigint,
	nevents bigint,
	specialhandling varchar(80),
	maxpss bigint,
	jobduration timestamp,
	esevents_ready bigint DEFAULT 0,
	esevents_sent bigint DEFAULT 0,
	esevents_running bigint DEFAULT 0,
	esevents_finished bigint DEFAULT 0,
	esevents_cancelled bigint DEFAULT 0,
	esevents_discarded bigint DEFAULT 0,
	esevents_done bigint DEFAULT 0,
	esevents_failed bigint DEFAULT 0,
	esevents_fatal bigint DEFAULT 0,
	esevents_merged bigint DEFAULT 0
) ;
ALTER TABLE pandamon_jobspage_arch_new OWNER TO panda;

CREATE TABLE pandamon_jobspage_init_old (
	data_snapshot_at timestamp,
	panda_attribute varchar(100),
	attr_value varchar(300),
	num_occurrences bigint
) ;
ALTER TABLE pandamon_jobspage_init_old OWNER TO panda;

CREATE TABLE pandamon_jobspage_new (
	part_id bigint,
	data_snapshot_at timestamp,
	pandaid bigint,
	retrial char(1),
	modificationtime timestamp,
	atlasrelease varchar(64),
	attemptnr smallint,
	computingsite varchar(128),
	cloud varchar(50),
	eventservice smallint,
	homepackage varchar(80),
	inputfileproject varchar(64),
	inputfiletype varchar(32),
	jeditaskid bigint,
	jobstatus varchar(15),
	jobsubstatus varchar(80),
	minramcount bigint,
	nucleus varchar(52),
	processingtype varchar(64),
	prodsourcelabel varchar(20),
	produsername varchar(60),
	reqid integer,
	transformation varchar(250),
	workinggroup varchar(20),
	brokerageerrorcode varchar(7),
	ddmerrorcode varchar(7),
	exeerrorcode varchar(7),
	jobdispatchererrorcode varchar(7),
	piloterrorcode varchar(7),
	superrorcode varchar(7),
	taskbuffererrorcode varchar(7),
	transexitcode varchar(7),
	actualcorecount integer DEFAULT 0,
	corecount smallint DEFAULT 1,
	jobsetid bigint,
	nevents bigint,
	specialhandling varchar(80),
	maxpss bigint,
	jobduration bigint,
	esevents_ready bigint,
	esevents_sent bigint,
	esevents_running bigint,
	esevents_finished bigint,
	esevents_cancelled bigint,
	esevents_discarded bigint,
	esevents_done bigint,
	esevents_failed bigint,
	esevents_fatal bigint,
	esevents_merged bigint
) ;
ALTER TABLE pandamon_jobspage_new OWNER TO panda;

CREATE TABLE panda_tasks_aggr (
	jeditaskid bigint NOT NULL,
	taskbody_crtime timestamp DEFAULT ((CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC')),
	taskbody_modiftime timestamp DEFAULT ((CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC')),
	taskbody_json text
) PARTITION BY RANGE (jeditaskid) ;
COMMENT ON TABLE panda_tasks_aggr IS E'Auxiliary table for storing in JSON document the result of aggregation per PanDA task done in python.';
ALTER TABLE panda_tasks_aggr OWNER TO panda;
CREATE INDEX panda_tasks_aggr_idx ON panda_tasks_aggr (jeditaskid, taskbody_modiftime);
ALTER TABLE panda_tasks_aggr ADD PRIMARY KEY (jeditaskid);
ALTER TABLE panda_tasks_aggr ADD CONSTRAINT panda_tasks_aggr_mtime_nn CHECK ((TASKBODY_MODIFTIME IS NOT NULL AND TASKBODY_MODIFTIME::text <> ''));
ALTER TABLE panda_tasks_aggr ADD CONSTRAINT panda_tasks_aggr_crtime_nn CHECK ((TASKBODY_CRTIME IS NOT NULL AND TASKBODY_CRTIME::text <> ''));

CREATE TABLE preprocess_groups (
	groupid numeric(38) NOT NULL,
	grouptypeid numeric(38) NOT NULL,
	timelowerbound timestamp,
	timeupperbound timestamp,
	lasttimeupdated timestamp,
	jsondata varchar(4000)
) ;
ALTER TABLE preprocess_groups OWNER TO panda;
ALTER TABLE preprocess_groups ADD PRIMARY KEY (groupid);

CREATE TABLE preprocess_groupskeys (
	groupid numeric(38),
	fieldname varchar(20),
	fieldvalue varchar(200),
	id bigint NOT NULL
) ;
ALTER TABLE preprocess_groupskeys OWNER TO panda;
ALTER TABLE preprocess_groupskeys ADD PRIMARY KEY (id);

CREATE TABLE preprocess_grouptypes (
	grouptypeid numeric(38) NOT NULL,
	fields varchar(200),
	page varchar(20)
) ;
ALTER TABLE preprocess_grouptypes OWNER TO panda;
ALTER TABLE preprocess_grouptypes ADD PRIMARY KEY (grouptypeid);

CREATE TABLE preprocess_jobs (
	pandaid numeric(38) NOT NULL,
	groupid numeric(38) NOT NULL,
	id bigint NOT NULL
) ;
ALTER TABLE preprocess_jobs OWNER TO panda;
CREATE INDEX preprocess_jobs_index1 ON preprocess_jobs (pandaid desc);
ALTER TABLE preprocess_jobs ADD PRIMARY KEY (id);

CREATE TABLE preprocess_queues (
	preptaskid bigint NOT NULL,
	grouptypeid bigint,
	jsondata varchar(2000),
	timeprepstarted timestamp
) ;
ALTER TABLE preprocess_queues OWNER TO panda;
ALTER TABLE preprocess_queues ADD PRIMARY KEY (preptaskid);

CREATE TABLE request_stats (
	id bigint NOT NULL,
	server varchar(40) NOT NULL,
	remote varchar(100) NOT NULL,
	qtime timestamp NOT NULL,
	qduration timestamp NOT NULL,
	load varchar(40) NOT NULL,
	mem varchar(40) NOT NULL,
	description varchar(4000) NOT NULL,
	url varchar(1000) NOT NULL,
	duration numeric(38) NOT NULL
) ;
COMMENT ON COLUMN request_stats.load IS E'CPU load on the PanDA monitor machine at the time of the query ';
COMMENT ON COLUMN request_stats.mem IS E'Memory usage at time of the query in MB';
COMMENT ON COLUMN request_stats.qduration IS E'End time of the query in UTC';
COMMENT ON COLUMN request_stats.qtime IS E'Start time of the query in UTC';
COMMENT ON COLUMN request_stats.remote IS E'IP address of the originating request';
COMMENT ON COLUMN request_stats.server IS E'Host name of the server executing the query';
COMMENT ON COLUMN request_stats.url IS E'URL of the query';
ALTER TABLE request_stats OWNER TO panda;
ALTER TABLE request_stats ADD PRIMARY KEY (id);

CREATE TABLE rucio_accounts (
	certificatedn varchar(250),
	rucio_account varchar(25),
	create_time timestamp DEFAULT ((CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'))
) ;
ALTER TABLE rucio_accounts OWNER TO panda;
CREATE INDEX rucio_accounts_idx ON rucio_accounts (certificatedn);

CREATE TABLE social_auth_association (
	id bigint NOT NULL,
	server_url varchar(255),
	handle varchar(255),
	secret varchar(255),
	issued bigint NOT NULL,
	lifetime bigint NOT NULL,
	assoc_type varchar(64)
) ;
ALTER TABLE social_auth_association OWNER TO panda;
ALTER TABLE social_auth_association ADD PRIMARY KEY (id);
ALTER TABLE social_auth_association ADD UNIQUE (server_url,handle);

CREATE TABLE social_auth_code (
	id bigint NOT NULL,
	email varchar(254),
	code varchar(32),
	verified smallint NOT NULL
) ;
ALTER TABLE social_auth_code OWNER TO panda;
CREATE INDEX social_auth_code_code_a2393167 ON social_auth_code (code);
ALTER TABLE social_auth_code ADD PRIMARY KEY (id);
ALTER TABLE social_auth_code ADD UNIQUE (email,code);
ALTER TABLE social_auth_code ADD CONSTRAINT sys_c0013273725 CHECK (verified IN (0,1));

CREATE TABLE social_auth_nonce (
	id bigint NOT NULL,
	server_url varchar(255),
	timestamp bigint NOT NULL,
	salt varchar(65)
) ;
ALTER TABLE social_auth_nonce OWNER TO panda;
ALTER TABLE social_auth_nonce ADD PRIMARY KEY (id);
ALTER TABLE social_auth_nonce ADD UNIQUE (server_url,timestamp,salt);

CREATE TABLE social_auth_partial (
	id bigint NOT NULL,
	token varchar(32),
	next_step bigint NOT NULL,
	backend varchar(32),
	data text
) ;
ALTER TABLE social_auth_partial OWNER TO panda;
CREATE INDEX social_aut_token_3017fea3 ON social_auth_partial (token);
ALTER TABLE social_auth_partial ADD PRIMARY KEY (id);
ALTER TABLE social_auth_partial ADD CONSTRAINT sys_c0013273741 CHECK (next_step >= 0);

CREATE TABLE social_auth_usersocialauth (
	id bigint NOT NULL,
	provider varchar(32),
	uid varchar(255),
	extra_data text,
	user_id bigint NOT NULL
) ;
ALTER TABLE social_auth_usersocialauth OWNER TO panda;
CREATE INDEX social_aut_user_id_17d28448 ON social_auth_usersocialauth (user_id);
ALTER TABLE social_auth_usersocialauth ADD PRIMARY KEY (id);
ALTER TABLE social_auth_usersocialauth ADD UNIQUE (provider,uid);

CREATE TABLE tmp_ids1debug (
	id bigint,
	transactionkey bigint,
	ins_time timestamp DEFAULT LOCALTIMESTAMP
) ;
ALTER TABLE tmp_ids1debug OWNER TO panda;

CREATE TABLE visits (
	visitid bigint NOT NULL,
	url varchar(1000),
	time timestamp DEFAULT CURRENT_TIMESTAMP,
	service numeric(38),
	userid numeric(38),
	remote varchar(100)
) ;
ALTER TABLE visits OWNER TO panda;
CREATE INDEX user_idx ON visits (userid);
ALTER TABLE visits ADD PRIMARY KEY (visitid);