import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProduct";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _isInitialize = false;

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialize) {
      String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct = context.read<Products>().findById(productId);
      }
    }

    _isInitialize = true;

    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      final products = context.read<Products>();
      
      if (_isEditForm) {
        products.updateProduct(_editedProduct);
      } else {
        products.addProduct(_editedProduct);
      }

      Navigator.of(context).pop();
    }
  }

  Product _updateEditedProduct({
    String title,
    double price,
    String description,
    String imageUrl,
  }) {
    _editedProduct = Product(
      id: _editedProduct.id,
      isFavorite: _editedProduct.isFavorite,
      title: title ?? _editedProduct.title,
      description: description ?? _editedProduct.description,
      price: price ?? _editedProduct.price,
      imageUrl: imageUrl ?? _editedProduct.imageUrl,
    );
  }

  bool get _isEditForm => _editedProduct.id != null;

  @override
  Widget build(BuildContext context) {
    if (_editedProduct?.imageUrl?.isNotEmpty ?? false) {
      _imageUrlController.text = _editedProduct.imageUrl;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: Text('${(_isEditForm ? 'Edit' : 'Create')} Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue: _editedProduct?.title,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              onSaved: (newValue) => _updateEditedProduct(
                title: newValue,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }

                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              initialValue: _editedProduct?.price.toString(),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              onSaved: (newValue) => _updateEditedProduct(
                price: double.parse(newValue),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a price.';
                }

                final valueParsed = double.tryParse(value);

                if (valueParsed == null) {
                  return 'Please enter a valid number.';
                }

                if (valueParsed <= 0) {
                  return 'Please enter a number greater than zero.';
                }

                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              initialValue: _editedProduct?.description,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              focusNode: _descriptionFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_imageUrlFocusNode);
              },
              onSaved: (newValue) => _updateEditedProduct(
                description: newValue,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a description.';
                }

                if (value.length < 10) {
                  return 'Should be at least 10 characters long.';
                }

                return null;
              },
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black38,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Enter a URL',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : FittedBox(
                          child: Image.network(_imageUrlController.text),
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                    onFieldSubmitted: (_) => _saveForm(),
                    onSaved: (newValue) => _updateEditedProduct(
                      imageUrl: newValue,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an image URL';
                      }

                      if (!value.endsWith('.png') &&
                          !value.endsWith('.jpg') &&
                          !value.endsWith('.jpeg') &&
                          !value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Please enter a valid image URL.';
                      }

                      return null;
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
