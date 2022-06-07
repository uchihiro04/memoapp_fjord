-- メモアプリのデータベース・テーブルの作成方法
-- データベースを作成する
CREATE DATABASE memoapp;
-- テーブルを作成する
CREATE TABLE memos
(id UUID NOT NULL DEFAULT gen_random_uuid(),
title TEXT NOT NULL,
content TEXT,
created_at timestamp DEFAULT now(),
PRIMARY KEY (id));
