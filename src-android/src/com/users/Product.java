package com.users;

public class Product {

	private String imageURL, url;
	private String price;
	
	public Product(String imageURL, String url, String price){
		this.setImageURL(imageURL);
		this.setUrl(url);
		this.setPrice(price);		
	}

	public String getImageURL() {
		return imageURL;
	}

	public void setImageURL(String imageURL) {
		this.imageURL = imageURL;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}
	
}
