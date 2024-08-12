import 'package:flutter/material.dart';
import 'package:myapp/helper/constants.dart';
import 'package:myapp/providers/app_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppProvider appProvider;

  @override
  void dispose() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        elevation: 6,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                child: appProvider.content.isEmpty
                    ? const Center(
                        child: Text(
                        'Start Conversation',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                    : ListView.separated(
                        controller: appProvider.scrollController,
                        itemCount: appProvider.content.length,
                        separatorBuilder: (sbCtx, sbI) {
                          return const Divider();
                        },
                        itemBuilder: (ctx, i) {
                          String text = appProvider.content[i];
                          return Text(text);
                        },
                      ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          appProvider.pickImage();
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          controller: appProvider.inputController,
                          decoration: const InputDecoration(
                            hintText: "Ask me anything...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.blue,
                        onPressed: () {
                          appProvider.continueChatsAPICall(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (appProvider.isLoading)
            Container(
              color: Colors.grey.withOpacity(0.8),
              // elevation: 0,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
