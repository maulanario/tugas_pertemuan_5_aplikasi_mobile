import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tugas_pertemuan_5/main.dart';
import 'package:http/http.dart' as http;

class NewData extends StatefulWidget {
  const NewData({Key? key}) : super(key: key);

  @override
  _NewDataState createState() => _NewDataState();
}

class _NewDataState extends State<NewData> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController salary = TextEditingController();

  Future<void> addData() async {
    if (name.text.isNotEmpty &&
        address.text.isNotEmpty &&
        salary.text.isNotEmpty) {
      var url = Uri.parse(
          'http://192.168.1.161/api_php/create.php'); // Inserting API Calling
      final response = await http.post(url, body: {
        "name": name.text,
        "address": address.text,
        "salary": salary.text,
      }); // parameter passed

      if (response.statusCode == 200) {
        // Jika data berhasil ditambahkan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil ditambahkan'),
          ),
        );

        // Kosongkan teks setelah berhasil menambahkan data
        name.clear();
        address.clear();
        salary.clear();

        // Kembali ke halaman sebelumnya
        Navigator.pop(context, true);
      } else {
        // Jika ada kesalahan dalam permintaan API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat menambahkan data'),
          ),
        );
      }
    } else {
      // Jika inputan kosong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap isi semua inputan tersebut'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tambah Karyawan',
          style: TextStyle(
            fontSize: 20.0,
            // color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukan Nama',
                hintText: 'Masukan Nama',
                prefixIcon: Icon(Icons.title),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 5,
              controller: address,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukan Alamat',
                hintText: 'Masukan Alamat',
                prefixIcon: Icon(Icons.text_snippet_outlined),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 5,
              controller: salary,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukan Gaji',
                hintText: 'Masukan Gaji',
                prefixIcon: Icon(Icons.text_snippet_outlined),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: MaterialButton(
              child: Text(
                "Add Data",
                style: TextStyle(
                    // color: Colors.white,
                    ),
              ),
              color: Colors.amber,
              onPressed: () {
                addData();
              },
              height: 45,
            ),
          )
        ],
      ),
    );
  }
}
