// library default_connector;

// import 'package:firebase_data_connect/firebase_data_connect.dart';

// class DefaultConnector {
//   static final ConnectorConfig connectorConfig = ConnectorConfig(
//     'us-central1',
//     'default',
//     'application',
//   );

//   static final DefaultConnector _instance = DefaultConnector._internal();

//   late final FirebaseDataConnect dataConnect;

//   DefaultConnector._internal() {
//     dataConnect = FirebaseDataConnect.instanceFor(
//       connectorConfig: connectorConfig,
//       sdkType: CallerSDKType.generated,
//     );
//   }

//   factory DefaultConnector() {
//     return _instance;
//   }
// }
