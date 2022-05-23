import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';

class ImageUploadForm extends StatefulWidget {
  const ImageUploadForm({Key? key, this.imageSource}) : super(key: key);

  final String? imageSource;
  @override
  State<ImageUploadForm> createState() => _ImageUploadFormState();
}

class _ImageUploadFormState extends State<ImageUploadForm> {
  final _imageSourceController = TextEditingController();
  String? imageString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 80,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(width: 0.1)),
        child: Column(
          children: [
            previewImageForm(),
            const SizedBox(height: 24),
            textImageUrlForm(),
            const SizedBox(height: 24),
            const Text(
              'Or',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 24),
            uploadImageForm(),
            submitButtonForm(),
          ],
        ),
      ),
    );
  }

  Widget previewImageForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        image: DecorationImage(
          image: loadImageProvider(imageString),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  Widget textImageUrlForm() {
    // TODO: Add to error handler
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _imageSourceController,
            decoration: const InputDecoration(
              hintText: 'Image url',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          iconSize: 40,
          onPressed: (() {
            setState(() {
              imageString = _imageSourceController.text;
            });
          }),
          icon: const Icon(
            Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }

  Widget uploadImageForm() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.grey[400]),
      onPressed: () {
        // TODO: Add image upload file from local
      },
      child: const Text('Chose file'),
    );
  }

  Widget submitButtonForm() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.headline6,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
              onPressed: () {
                // Back to previous screen with value
                Navigator.pop(context, imageString);
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // Implement initState
    super.initState();
    if (widget.imageSource != null) {
      imageString = widget.imageSource;
    }
  }

  @override
  void dispose() {
    _imageSourceController.dispose();

    // Implemant dispose
    super.dispose();
  }
}
