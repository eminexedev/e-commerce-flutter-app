class ProductModel {
	final int id;
	final String name;
	final String tagline;
	final String description;
	final String price;
	final String currency;
	final String image;
	final Map<String, dynamic> specs;

	const ProductModel({
		required this.id,
		required this.name,
		required this.tagline,
		required this.description,
		required this.price,
		required this.currency,
		required this.image,
		required this.specs,
	});

	factory ProductModel.fromJson(Map<String, dynamic> json) {
		return ProductModel(
			id: _asInt(json['id']),
			name: _asString(json['name']),
			tagline: _asString(json['tagline']),
			description: _asString(json['description']),
			price: _asString(json['price']),
			currency: _asString(json['currency']),
			image: _asString(json['image']),
			specs: (json['specs'] as Map<String, dynamic>?) ?? const {},
		);
	}

	static int _asInt(dynamic value) {
		if (value is int) return value;
		if (value is num) return value.toInt();
		return int.tryParse(value?.toString() ?? '') ?? 0;
	}

	static String _asString(dynamic value) {
		if (value == null) return '';
		final text = value.toString();
		return text == 'null' ? '' : text;
	}
}
