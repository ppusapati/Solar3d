//
//  Generated code. Do not modify.
//  source: interconnection/v1/interconnection.proto
//

import "package:connectrpc/connect.dart" as connect;
import "interconnection.pb.dart" as interconnectionv1interconnection;
import "interconnection.connect.spec.dart" as specs;

/// InterconnectionService manages utility Point of Interconnection (POI)
/// modeling, transformer/substation sizing, reactive power studies, and
/// interconnection application form generation.
extension type InterconnectionServiceClient (connect.Transport _transport) {
  Future<interconnectionv1interconnection.CreatePOIResponse> createPOI(
    interconnectionv1interconnection.CreatePOIRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InterconnectionService.createPOI,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<interconnectionv1interconnection.GetPOIResponse> getPOI(
    interconnectionv1interconnection.GetPOIRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InterconnectionService.getPOI,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<interconnectionv1interconnection.ListPOIsResponse> listPOIs(
    interconnectionv1interconnection.ListPOIsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InterconnectionService.listPOIs,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<interconnectionv1interconnection.SizeTransformerResponse> sizeTransformer(
    interconnectionv1interconnection.SizeTransformerRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InterconnectionService.sizeTransformer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<interconnectionv1interconnection.ReactivePowerStudyResponse> reactivePowerStudy(
    interconnectionv1interconnection.ReactivePowerStudyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InterconnectionService.reactivePowerStudy,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<interconnectionv1interconnection.GenerateApplicationFormResponse> generateApplicationForm(
    interconnectionv1interconnection.GenerateApplicationFormRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InterconnectionService.generateApplicationForm,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<interconnectionv1interconnection.DeletePOIResponse> deletePOI(
    interconnectionv1interconnection.DeletePOIRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InterconnectionService.deletePOI,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
