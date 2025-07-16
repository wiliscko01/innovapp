import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FileUploadWidget extends StatefulWidget {
  final List<Map<String, dynamic>> uploadedFiles;
  final Function(List<Map<String, dynamic>>) onFilesChanged;

  const FileUploadWidget({
    Key? key,
    required this.uploadedFiles,
    required this.onFilesChanged,
  }) : super(key: key);

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  bool _isUploading = false;

  // Mock file types
  final List<Map<String, dynamic>> supportedTypes = [
    {"name": "Images", "extensions": "JPG, PNG, GIF", "icon": "image"},
    {
      "name": "Documents",
      "extensions": "PDF, DOC, DOCX",
      "icon": "description"
    },
    {"name": "Vidéos", "extensions": "MP4, MOV, AVI", "icon": "videocam"},
    {"name": "Archives", "extensions": "ZIP, RAR", "icon": "archive"},
  ];

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.neutralMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Ajouter des fichiers',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Upload options
            _buildUploadOption(
              icon: 'camera_alt',
              title: 'Prendre une photo',
              subtitle: 'Capturer avec l\'appareil photo',
              onTap: () {
                Navigator.pop(context);
                _simulateFileUpload('camera');
              },
            ),
            SizedBox(height: 2.h),
            _buildUploadOption(
              icon: 'photo_library',
              title: 'Galerie',
              subtitle: 'Choisir depuis la galerie',
              onTap: () {
                Navigator.pop(context);
                _simulateFileUpload('gallery');
              },
            ),
            SizedBox(height: 2.h),
            _buildUploadOption(
              icon: 'folder',
              title: 'Fichiers',
              subtitle: 'Parcourir les documents',
              onTap: () {
                Navigator.pop(context);
                _simulateFileUpload('files');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(color: AppTheme.lightTheme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.primaryOrange,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralMedium,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.neutralMedium,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _simulateFileUpload(String source) {
    setState(() {
      _isUploading = true;
    });

    // Simulate upload delay
    Future.delayed(Duration(seconds: 2), () {
      final newFile = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "name": source == 'camera'
            ? "photo_${DateTime.now().millisecondsSinceEpoch}.jpg"
            : source == 'gallery'
                ? "image_${DateTime.now().millisecondsSinceEpoch}.png"
                : "document_${DateTime.now().millisecondsSinceEpoch}.pdf",
        "size": "2.5 MB",
        "type":
            source == 'camera' || source == 'gallery' ? "image" : "document",
        "uploadProgress": 100.0,
        "status": "completed",
        "url": "https://via.placeholder.com/150",
      };

      final updatedFiles =
          List<Map<String, dynamic>>.from(widget.uploadedFiles);
      updatedFiles.add(newFile);

      setState(() {
        _isUploading = false;
      });

      widget.onFilesChanged(updatedFiles);
    });
  }

  void _removeFile(int index) {
    final updatedFiles = List<Map<String, dynamic>>.from(widget.uploadedFiles);
    updatedFiles.removeAt(index);
    widget.onFilesChanged(updatedFiles);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documents et fichiers',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Ajoutez des fichiers pour nous aider à mieux comprendre votre projet',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralMedium,
            ),
          ),
          SizedBox(height: 3.h),

          // Upload area
          GestureDetector(
            onTap: _showUploadOptions,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: AppTheme.primaryOrange,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'cloud_upload',
                      color: AppTheme.primaryOrange,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Cliquez pour ajouter des fichiers',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'ou glissez-déposez vos fichiers ici',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Supported file types
          Text(
            'Types de fichiers supportés',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 1.h,
              childAspectRatio: 3,
            ),
            itemCount: supportedTypes.length,
            itemBuilder: (context, index) {
              final type = supportedTypes[index];
              return Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(color: AppTheme.lightTheme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: type['icon'],
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            type['name'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            type['extensions'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.neutralMedium,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Uploaded files
          if (widget.uploadedFiles.isNotEmpty || _isUploading) ...[
            SizedBox(height: 3.h),
            Text(
              'Fichiers ajoutés',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),

            // Show uploading indicator
            if (_isUploading)
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(color: AppTheme.lightTheme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryOrange),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Téléchargement en cours...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

            // Show uploaded files
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.uploadedFiles.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final file = widget.uploadedFiles[index];
                return Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(color: AppTheme.lightTheme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName:
                              file['type'] == 'image' ? 'image' : 'description',
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file['name'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              file['size'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.neutralMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeFile(index),
                        icon: CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.errorRed,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          SizedBox(height: 3.h),

          // File size limit info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.warningAmber,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Taille maximale par fichier: 10 MB. Total maximum: 50 MB.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningAmber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
