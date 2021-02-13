-- create database
drop database if exists pubsuk;
create database pubsuk;

-- connect to database
\c pubsuk;

-- create schema
drop schema if exists ttt;
create schema ttt;

-- create extension to uuid functions
create extension if not exists "uuid-ossp";
-- create extension to coordination things
create extension if not exists "postgis";
-- create extension to use citext instead text
create extension if not exists "citext";

