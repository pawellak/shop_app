import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:validators/validators.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = false;
  var _isLoading = false;
  var _editedProduct = Product(
      id: '',
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
      isFavorite: false);

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
      var productIdInit = ModalRoute.of(context)!.settings.arguments;
      if (productIdInit != null) {
        final product = Provider.of<Products>(context, listen: false)
            .findById(productIdInit.toString());
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _imageUrlController.text = _editedProduct.imageUrl,
        };
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!isURL(_imageUrlController.text.toString())) return;
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;

    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);



    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('An error occurred!'),
              content: const Text('Something went wrong'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(children: [
                  TextFormField(
                      initialValue: _initValues['title'],
                      validator: (value) {
                        if (value == null) return 'Value is empty';
                        if (value.isEmpty) return 'Value is empty';
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (newValue) {
                        if (newValue != null) {
                          _editedProduct = Product(
                              title: newValue,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite);
                        }
                      }),
                  TextFormField(
                    initialValue: _initValues['price'],
                    validator: (value) {
                      if (value == null) return 'Value is empty';
                      if (value.isEmpty) return 'Value is empty';
                      if (double.tryParse(value) == null) {
                        return 'Value is not a number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a value grater than zero';
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            description: _editedProduct.description,
                            price: double.parse(newValue),
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      }
                    },
                  ),
                  TextFormField(
                      initialValue: _initValues['description'],
                      validator: (value) {
                        if (value == null) return 'Value is empty';
                        if (value.isEmpty) return 'Value is empty';
                        if (value.length < 5) return 'Description is too short';
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (newValue) {
                        if (newValue != null) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              imageUrl: _editedProduct.imageUrl,
                              description: newValue,
                              price: _editedProduct.price,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite);
                        }
                      }),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.yellow)),
                        child: _imageUrlController.text.isEmpty
                            ? const Text('Enter URL')
                            : FittedBox(
                                child: Image.network(_imageUrlController.text),
                                fit: BoxFit.fill,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null) return 'Value is empty';
                            if (value.isEmpty) return 'Value is empty';
                            if (!isURL(value)) return 'Url incorrect';
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  imageUrl: newValue,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite);
                            }
                          },
                          onEditingComplete: () {
                            if (!isURL(_imageUrlController.text.toString())) {
                              return;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }
}
