/// Interactive basketball shot file upload animation package for Flutter.
/// Provides aiming trajectory, net swish physics, upload progress bar,
/// and local device file picker with preset sample documents.
library;

// Core Widget
export 'basketball_file_picker.dart';

// Models
export 'models/sample_file.dart';
export 'models/selected_file_data.dart';
export 'models/shot_state.dart';

// Physics & Math
export 'utils/trajectory_physics.dart';

// Subwidgets
export 'widgets/aiming_hint_badge.dart';
export 'widgets/basketball_goal.dart';
export 'widgets/basketball_net.dart';
export 'widgets/draggable_pdf_launcher.dart';
export 'widgets/flying_pdf_document.dart';
export 'widgets/hoop_rim.dart';
export 'widgets/mini_pdf_icon.dart';
export 'widgets/pdf_document_widget.dart';
export 'widgets/pdf_picker_bottom_sheet.dart';
export 'widgets/top_drop_zone.dart';
export 'widgets/trajectory_arc.dart';
export 'widgets/upload_status_card.dart';

// Painters
export 'widgets/painters/basketball_net_painter.dart';
export 'widgets/painters/dashed_rect_painter.dart';
export 'widgets/painters/folded_corner_painter.dart';
export 'widgets/painters/hoop_rim_painter.dart';
export 'widgets/painters/trajectory_painter.dart';

import 'basketball_file_picker.dart';

/// Convenient alias for [BasketballFilePicker].
typedef FilePickAnimation = BasketballFilePicker;
