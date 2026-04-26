//
//  Generated code. Do not modify.
//  source: interconnection/v1/interconnection.proto
//

import "package:connectrpc/connect.dart" as connect;
import "interconnection.pb.dart" as interconnectionv1interconnection;

/// InterconnectionService manages utility Point of Interconnection (POI)
/// modeling, transformer/substation sizing, reactive power studies, and
/// interconnection application form generation.
abstract final class InterconnectionService {
  /// Fully-qualified name of the InterconnectionService service.
  static const name = 'interconnection.v1.InterconnectionService';

  static const createPOI = connect.Spec(
    '/$name/CreatePOI',
    connect.StreamType.unary,
    interconnectionv1interconnection.CreatePOIRequest.new,
    interconnectionv1interconnection.CreatePOIResponse.new,
  );

  static const getPOI = connect.Spec(
    '/$name/GetPOI',
    connect.StreamType.unary,
    interconnectionv1interconnection.GetPOIRequest.new,
    interconnectionv1interconnection.GetPOIResponse.new,
  );

  static const listPOIs = connect.Spec(
    '/$name/ListPOIs',
    connect.StreamType.unary,
    interconnectionv1interconnection.ListPOIsRequest.new,
    interconnectionv1interconnection.ListPOIsResponse.new,
  );

  static const sizeTransformer = connect.Spec(
    '/$name/SizeTransformer',
    connect.StreamType.unary,
    interconnectionv1interconnection.SizeTransformerRequest.new,
    interconnectionv1interconnection.SizeTransformerResponse.new,
  );

  static const reactivePowerStudy = connect.Spec(
    '/$name/ReactivePowerStudy',
    connect.StreamType.unary,
    interconnectionv1interconnection.ReactivePowerStudyRequest.new,
    interconnectionv1interconnection.ReactivePowerStudyResponse.new,
  );

  static const generateApplicationForm = connect.Spec(
    '/$name/GenerateApplicationForm',
    connect.StreamType.unary,
    interconnectionv1interconnection.GenerateApplicationFormRequest.new,
    interconnectionv1interconnection.GenerateApplicationFormResponse.new,
  );

  static const deletePOI = connect.Spec(
    '/$name/DeletePOI',
    connect.StreamType.unary,
    interconnectionv1interconnection.DeletePOIRequest.new,
    interconnectionv1interconnection.DeletePOIResponse.new,
  );
}
