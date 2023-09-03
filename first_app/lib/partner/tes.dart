import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
//import 'package:file_picker/_internal/file_picker_web.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PlatformFile> _attachments = [];

  getPics() async {
    final List<Object> supaPaths = [];
    final pics = await supabase.storage.from('shop_produk').list();

    if (pics.isEmpty) return;

    Future.wait(
      pics.map(
        (p) async {
          final res = supabase.storage.from('shop_produk').getPublicUrl(p.name);
          supaPaths.add({"path": res, "name": p.name});
        },
      ),
    );
    return supaPaths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(100.0, 40.0, 100.0, 20.0),
        child: Column(
          children: [
            const Text(
              'SupaImages',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Manage your images with Supabase Storage',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  wordSpacing: 3,
                  letterSpacing: 3),
            ),
            const SizedBox(height: 60),
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(
                    Icons.image,
                    size: 15,
                  ),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png'],
                    );

                    if (result == null) {
                      print("No file selected");
                    } else {
                      try {
                        result.files.map(
                          (file) {
                            _attachments.add(file);
                          },
                        ).toList();

                        await Future.wait(
                          _attachments.map(
                            (attch) async {
                              final fileBytes = attch.bytes;
                              final fileName = attch.name;

                              await supabase.storage
                                  .from('shop_produk')
                                  .uploadBinary(
                                    fileName,
                                    fileBytes!,
                                  );
                            },
                          ),
                        );
                        setState(() {});
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Error uploading file: ${e.toString()}'),
                          ),
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: Colors.pink,
                        width: 1,
                      ),
                    ),
                  ),
                  label: const Text(
                    "Upload Images",
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {}, child: const Text('Logout'))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: getPics(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final picInfo = snapshot.data! as List;
                    return GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      children: [
                        ...picInfo.map(
                          (pInfo) => Card(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.network(
                                      pInfo['path'],
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                      onPressed: () async {
                                        await supabase.storage
                                            .from('shop_produk')
                                            .remove([pInfo['name']]);
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 15,
                                      ),
                                      label: const Text('Delete')),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No images uploaded yet'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
