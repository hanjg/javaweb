package com.bbs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class Article {
	private int id;
	
	private int parentId;
	
	private int rootId;
	
	private String title;
	
	private String content;
	
	private Date publishDate;
	
	private boolean isLeaf;
	
	private int grade;
	
	public void initFromResultSet(ResultSet resultSet, int grade) {
		try {
			setId(resultSet.getInt("id"));
			setParentId(resultSet.getInt("parentId"));
			setRootId(resultSet.getInt("rootId"));
			setTitle(resultSet.getString("title"));
			setContent(resultSet.getString("content"));
			setPublishDate(resultSet.getTimestamp("publishDate"));
			setLeaf(resultSet.getBoolean("isLeaf"));
			setGrade(grade);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getParentId() {
		return parentId;
	}

	public void setParentId(int parentId) {
		this.parentId = parentId;
	}

	public int getRootId() {
		return rootId;
	}

	public void setRootId(int rootId) {
		this.rootId = rootId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Date getPublishDate() {
		return publishDate;
	}

	public void setPublishDate(Date publishDate) {
		this.publishDate = publishDate;
	}

	public boolean isLeaf() {
		return isLeaf;
	}

	public void setLeaf(boolean isLeaf) {
		this.isLeaf = isLeaf;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}
}
