import { createClient } from '@connectrpc/connect';
import { createConnectTransport } from '@connectrpc/connect-web';
import type { DescService } from '@bufbuild/protobuf';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import { timestampDate, timestampFromDate } from '@bufbuild/protobuf/wkt';

import { API_BASE } from './client';

const transport = createConnectTransport({
	baseUrl: API_BASE
});

export function createApiClient<T extends DescService>(service: T) {
	return createClient(service, transport);
}

export function timestampToIso(timestamp?: Timestamp): string {
	return timestamp ? timestampDate(timestamp).toISOString() : '';
}

export function isoToTimestamp(value?: string): Timestamp | undefined {
	if (!value) {
		return undefined;
	}
	return timestampFromDate(new Date(value));
}
