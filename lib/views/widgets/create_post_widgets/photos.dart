import 'package:flutter/material.dart';

class CreatePostPhotos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _addPhotosTextBuilder(),
        ),
        SizedBox(
          height: 10.0,
        ),
        _addPhotoBuilder(),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _addPhotosTextBuilder() {
    return Text(
      'Photos',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _addPhotoBuilder() {
    final _list = [null, null, null];
    return Container(
      height: 120.0,
      child: ListView.builder(
        itemCount: _list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.green,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: Colors.green,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return _imgListItemBuilder();
        },
      ),
    );
  }

  Widget _imgListItemBuilder() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/sample2.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 40.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 18.0,
                  color: Colors.grey[100],
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
