import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:n_image_picker/n_image_picker.dart';

const String kDefaultUrl = 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg';
const String kSampleJpeg = 'https://i.imgur.com/f1fRugF.jpeg';
const String kSampleGif  =
'https://mir-s3-cdn-cf.behance.net/project_modules/hd/5eeea355389655.59822ff824b72.gif';
const String kAssetImage = 'assets/flutter_logo.png';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
  MaterialApp(
    title                     : 'n_image_picker demo',
    debugShowCheckedModeBanner: false,
    theme                     :
    ThemeData(
      useMaterial3: true,
      brightness  : Brightness.dark,
      // colorScheme : ColorScheme.fromSeed(seedColor: const Color(0xFF7C4DFF)),
    ),
    home: const DemoPage(),
  );
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {

  late final ImageController _labController;
  late final ImageController _pickController;
  late final ImageController _dragController;

  final TextEditingController _urlField = TextEditingController(text: kDefaultUrl);
  final TextEditingController _keyField = TextEditingController(text: 'image');

  int    _maxSize  = 250;
  bool   _resizeOn = true;
  String _source   = kDefaultUrl;

  @override
  void initState() {
    super.initState();

    _labController  = ImageController(key: _keyField.text, maxSize: _maxSize);
    _pickController = ImageController(key: 'avatar');
    _dragController = ImageController(key: 'dropped');

    for (final ImageController controller in [_labController, _pickController, _dragController]) {
      controller.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    for (final ImageController controller in [_labController, _pickController, _dragController]) {
      controller..removeListener(_rebuild)..dispose();
    }
    _urlField.dispose();
    _keyField.dispose();
    super.dispose();
  }

  void _rebuild() { try { if(mounted) setState(() {}); } catch (e) { null; } }

  Future<void> _load(String url) async {
    if(url.isEmpty) return;
    setState(() => _source = url);
    await _labController.fromUrl(headers: null, url: url);
  }

  void _reloadCurrent() => _load(_source);

  void _applyMaxSize(double value) {
    setState(() {
      _maxSize  = value.round();
      _resizeOn = true;
    });
    _labController.updateMaxSize(_maxSize);
    _reloadCurrent();
  }

  void _toggleResize(bool value) {
    setState(() => _resizeOn = value);
    _labController.updateMaxSize(value ? _maxSize : 1 << 30);
    _reloadCurrent();
  }

  @override
  Widget build(BuildContext context) =>
  Scaffold(
    body:
    DecoratedBox(
      decoration:
      const BoxDecoration(
        gradient:
        LinearGradient(
          begin : Alignment.topLeft,
          end   : Alignment.bottomRight,
          colors: [Color(0xFF151226), Color(0xFF1E1535), Color(0xFF0F0F17)],
          stops : [0.0, 0.55, 1.0],
        ),
      ),
      child:
      SafeArea(
        child:
        Center(
          child:
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child      :
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child  :
              Column(
                crossAxisAlignment : CrossAxisAlignment.stretch,
                spacing            : 24,
                children           : [
                  const HeaderBar(),
                  LabSection(
                    controller      : _labController,
                    urlField        : _urlField,
                    keyField        : _keyField,
                    maxSize         : _maxSize,
                    resizeOn        : _resizeOn,
                    onLoadUrl       : _load,
                    onReload        : _reloadCurrent,
                    onPreviewSize   : (value) => setState(() => _maxSize = value.round()),
                    onApplyMaxSize  : _applyMaxSize,
                    onToggleResize  : _toggleResize,
                  ),
                  GallerySection(
                    pickController : _pickController,
                    dragController : _dragController,
                  ),
                  const FooterNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

}


class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return
    Row(
      children: [
        Container(
          width       : 56,
          height      : 56,
          decoration  :
          BoxDecoration(
            gradient    :
            const LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFFFF4081)]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.image_outlined, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children          : [
              Text(
                'n_image_picker',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Interactive demo: URL loading, native picker, resizing, preview and drag & drop',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
        const Chip(
          avatar: Icon(Icons.tag, size: 16, color: Colors.white70),
          label : Text('4.2.0'),
        ),
      ],
    );
  }

}


class LabSection extends StatelessWidget {
  final ImageController   controller;
  final TextEditingController urlField;
  final TextEditingController keyField;
  final int                   maxSize;
  final bool                  resizeOn;
  final ValueChanged<String>  onLoadUrl;
  final VoidCallback          onReload;
  final ValueChanged<double>  onPreviewSize;
  final ValueChanged<double>  onApplyMaxSize;
  final ValueChanged<bool>    onToggleResize;

  const LabSection({
    super.key,
    required this.controller,
    required this.urlField,
    required this.keyField,
    required this.maxSize,
    required this.resizeOn,
    required this.onLoadUrl,
    required this.onReload,
    required this.onPreviewSize,
    required this.onApplyMaxSize,
    required this.onToggleResize,
  });

  @override
  Widget build(BuildContext context) =>
  SectionCard(
    title    : 'Load & resize lab',
    subtitle : 'URL input, multipart key and maxSize applied on every reload',
    child    :
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing           : 14,
      children          : [
        ImageArea(
          controller     : controller,
          onLoadingImage : kDefaultUrl,
          width          : double.infinity,
          height         : 300,
          fit            : BoxFit.cover,
          decoration     : kAreaDecoration,
          onLoadingChild : const LoadingPlaceholder(),
          onErrorChild   : ErrorPlaceholder(onRetry: onReload),
          onEmptyChild   : const EmptyPlaceholder(message: 'No image'),
          onFullChild    : GlassControls(controller: controller),
        ),

        MetaDataChips(controller: controller, maxSize: maxSize, resizeOn: resizeOn),

        Row(
          spacing : 10,
          children: [
            Expanded(
              child:
              TextField(
                controller : urlField,
                onSubmitted: onLoadUrl,
                decoration :
                InputDecoration(
                  prefixIcon : const Icon(Icons.link),
                  labelText : 'Image URL',
                  border    :
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            FilledButton.icon(
              onPressed : () => onLoadUrl(urlField.text.trim()),
              icon      : const Icon(Icons.cloud_download_outlined),
              label     : const Text('Load'),
            ),
          ],
        ),

        Wrap(
          spacing          : 8,
          runSpacing       : 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children         : [
            ActionChip(
              avatar   : const Icon(Icons.image, size: 16),
              label    : const Text('JPEG'),
              onPressed: () {
                urlField.text = kSampleJpeg;
                onLoadUrl(kSampleJpeg);
              },
            ),
            ActionChip(
              avatar   : const Icon(Icons.animation, size: 16),
              label    : const Text('GIF (ignores maxSize)'),
              onPressed: () {
                urlField.text = kSampleGif;
                onLoadUrl(kSampleGif);
              },
            ),
            SizedBox(
              width: 150,
              child:
              TextField(
                controller: keyField,
                onChanged : controller.updateKey,
                decoration:
                InputDecoration(
                  labelText : 'multipart key',
                  border    :
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  isDense   : true,
                ),
              ),
            ),
          ],
        ),

        const Divider(),

        Row(
          spacing : 12,
          children: [
            const Icon(Icons.photo_size_select_large_outlined),
            Switch(value: resizeOn, onChanged: onToggleResize),
            Expanded(
              child:
              Slider(
                value      : maxSize.toDouble(),
                min        : 50,
                max        : 2000,
                divisions  : 39,
                label      : '$maxSize px',
                onChanged  : resizeOn ? onPreviewSize : null,
                onChangeEnd: resizeOn ? onApplyMaxSize : null,
              ),
            ),
            SizedBox(
              width : 80,
              child :
              Text(
                '$maxSize px',
                textAlign: TextAlign.end,
                style    :
                Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Text(
          'Move the slider to resize: it calls updateMaxSize and reloads the image. '
          'Watch the bytes chip change (only bmp, cur, jpg, png, pvr, tga, tiff formats apply).',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white38),
        ),
      ],
    ),
  );

}


class GallerySection extends StatelessWidget {
  final ImageController pickController;
  final ImageController dragController;

  const GallerySection({
    super.key,
    required this.pickController,
    required this.dragController,
  });

  @override
  Widget build(BuildContext context) =>
  SectionCard(
    title    : 'Modes gallery',
    subtitle : 'square mode, asset without controller and web-only drag & drop',
    child    :
    Wrap(
      alignment : WrapAlignment.spaceEvenly,
      spacing   : 20,
      runSpacing: 20,
      children  : [
        CaptionedArea(caption: 'native pickImage', child: PickerTile(controller: pickController)),
        const CaptionedArea(caption: 'asset without controller', child: AssetTile()),
        if(kIsWeb || kIsWasm)
        CaptionedArea(caption: 'drag & drop (web only)', child: DragTile(controller: dragController)),
      ],
    ),
  );

}


class PickerTile extends StatelessWidget {
  final ImageController controller;

  const PickerTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) =>
  ImageArea.square(
    controller  : controller,
    dimension   : 160,
    decoration  : kAreaDecoration,
    onFullChild : GlassControls(controller: controller),
    onEmptyChild:
    Center(
      child:
      InkWell(
        borderRadius : BorderRadius.circular(24),
        onTap        : () => controller.pickImage(),
        child        :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize     : MainAxisSize.min,
          spacing          : 6,
          children         : [
            Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey.shade400),
            Text('Pick', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
      ),
    ),
  );

}


class AssetTile extends StatelessWidget {
  const AssetTile({super.key});

  @override
  Widget build(BuildContext context) =>
  ImageArea.square(
    dimension     : 160,
    padding       : const EdgeInsets.all(16),
    fit           : BoxFit.contain,
    decoration    : kAreaDecoration,
    onLoadingImage: kAssetImage,
  );

}


class DragTile extends StatelessWidget {
  final ImageController controller;

  const DragTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) =>
  ImageArea.square(
    controller  : controller,
    dimension   : 160,
    decoration  : kAreaDecoration,
    onDragChild :
    Container(
      decoration :
      BoxDecoration(
        gradient    :
        const LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFFFF4081)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child      :
      const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize     : MainAxisSize.min,
        spacing          : 6,
        children         : [
          Icon(Icons.download_for_offline_outlined, color: Colors.white, size: 40),
          Text('DROP IT!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    onEmptyChild:
    Center(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize     : MainAxisSize.min,
        spacing          : 6,
        children         : [
          Icon(Icons.drag_handle, size: 40, color: Colors.grey.shade500),
          Text('Drag here', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    ),
    onErrorChild:
    const Center(child: Icon(Icons.error_outline, color: Colors.redAccent, size: 36)),
  );

}


class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) =>
  const Center(
    child:
    Column(
      mainAxisSize: MainAxisSize.min,
      spacing     : 10,
      children    : [
        CircularProgressIndicator(),
        Text('Loading...', style: TextStyle(color: Colors.white60)),
      ],
    ),
  );

}


class ErrorPlaceholder extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorPlaceholder({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) =>
  Center(
    child:
    Column(
      mainAxisSize: MainAxisSize.min,
      spacing     : 8,
      children    : [
        const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
        const Text('Could not load the image', style: TextStyle(color: Colors.white70)),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );

}


class EmptyPlaceholder extends StatelessWidget {
  final String message;

  const EmptyPlaceholder({super.key, required this.message});

  @override
  Widget build(BuildContext context) =>
  Center(
    child:
    Column(
      mainAxisSize: MainAxisSize.min,
      spacing     : 8,
      children    : [
        Icon(Icons.add_photo_alternate_outlined, size: 44, color: Colors.grey.shade500),
        Text(message, style: TextStyle(color: Colors.grey.shade500)),
      ],
    ),
  );

}


class GlassControls extends StatelessWidget {
  final ImageController controller;

  const GlassControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) =>
  Container(
    padding     : const EdgeInsets.all(4),
    decoration  :
    BoxDecoration(
      color       : const Color.fromRGBO(15, 15, 25, 0.45),
      borderRadius: BorderRadius.circular(20),
      border      : Border.all(color: Colors.white24),
    ),
    clipBehavior: Clip.hardEdge,
    child       :
    BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child :
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing     : 2,
        children    : [
          IconButton(
            tooltip  : 'Replace',
            onPressed: () => controller.pickImage(),
            icon     : const Icon(Icons.folder_open_outlined, size: 20),
            color    : Colors.lightBlueAccent,
          ),
          IconButton(
            tooltip  : 'Preview',
            onPressed: controller.hasNoImage ? null : () => controller.preview(context),
            icon     : const Icon(Icons.zoom_out_map, size: 20),
            color    : controller.hasImage ? Colors.greenAccent : Colors.grey,
          ),
          IconButton(
            tooltip  : 'Remove',
            onPressed: controller.hasNoImage ? null : () => controller.removeImage(),
            icon     : const Icon(Icons.delete_outline, size: 20),
            color    : controller.hasImage ? Colors.redAccent : Colors.grey,
          ),
        ],
      ),
    ),
  );

}


class MetaDataChips extends StatelessWidget {
  final ImageController controller;
  final int             maxSize;
  final bool            resizeOn;

  const MetaDataChips({
    super.key,
    required this.controller,
    required this.maxSize,
    required this.resizeOn,
  });

  @override
  Widget build(BuildContext context) {
    final Size?    size    = controller.size;
    final Uint8List? bytes  = controller.bytes;

    return
    Wrap(
      spacing   : 8,
      runSpacing: 8,
      children  : [
        MetaChip(icon: Icons.badge_outlined,       label: 'name',    value: controller.name ?? '-'),
        MetaChip(icon: Icons.description_outlined, label: 'ext',     value: controller.extension ?? '-'),
        MetaChip(
          icon : Icons.aspect_ratio_outlined,
          label: 'size',
          value: size == null ? '-' : '${size.width.toInt()} x ${size.height.toInt()}',
        ),
        MetaChip(
          icon : Icons.memory_outlined,
          label: 'bytes',
          value: bytes == null ? '-' : '${(bytes.lengthInBytes / 1024).toStringAsFixed(1)} KB',
        ),
        MetaChip(icon: Icons.vpn_key_outlined,     label: 'field',   value: controller.multipartFile?.field ?? '-'),
        MetaChip(icon: Icons.photo_size_select_small_outlined, label: 'maxSize', value: resizeOn ? '$maxSize px' : 'no limit'),
      ],
    );
  }

}


class MetaChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;

  const MetaChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) =>
  Container(
    padding     : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration  :
    BoxDecoration(
      color       : Colors.white.withAlpha(12),
      borderRadius: BorderRadius.circular(12),
      border      : Border.all(color: Colors.white10),
    ),
    child       :
    Row(
      mainAxisSize: MainAxisSize.min,
      spacing     : 6,
      children    : [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.primaryFixedDim),
        Text('$label:', style: const TextStyle(fontSize: 11, color: Colors.white38)),
        Text(
          value,
          style:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
        ),
      ],
    ),
  );

}


class CaptionedArea extends StatelessWidget {
  final String caption;
  final Widget child;

  const CaptionedArea({super.key, required this.caption, required this.child});

  @override
  Widget build(BuildContext context) =>
  Column(
    spacing: 8,
    children: [
      child,
      Text(caption, style: const TextStyle(color: Colors.white38, fontSize: 12)),
    ],
  );

}


class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return
    Container(
      padding     : const EdgeInsets.all(20),
      decoration  :
      BoxDecoration(
        color       : Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(28),
        border      : Border.all(color: Colors.white10),
      ),
      child       :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing           : 16,
        children          : [
          Row(
            children: [
              Container(
                width       : 4,
                height      : 22,
                decoration  :
                BoxDecoration(
                  color       : const Color(0xFF7C4DFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children          : [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white38)),
                  ],
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

}


final BoxDecoration kAreaDecoration =
BoxDecoration(
  color        : const Color(0xFF221A38),
  borderRadius : BorderRadius.circular(24),
  border       : Border.all(width: 1, color: Colors.white12),
  boxShadow    : const [
    BoxShadow(color: Colors.black45, blurRadius: 18, offset: Offset(0, 8))
  ],
);


class FooterNote extends StatelessWidget {
  const FooterNote({super.key});

  @override
  Widget build(BuildContext context) =>
  Text(
    'Formats: jpg, jpeg, png, gif, bmp, tiff, tga, pvr, ico, webp, psd, exr, pnm   |   '
    'Drag & drop is web only. The GIF sample ignores maxSize because gif is not a resizable format.',
    textAlign: TextAlign.center,
    style    : Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white30),
  );

}
