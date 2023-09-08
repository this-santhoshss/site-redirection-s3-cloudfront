function handler(event) {
  // Redirect from apex to subdomain (blog).
  var request = event.request;

  if (request.headers.host) {
    var host = request.headers.host.value;
    if (host === "cntechy.com" || host === "www.cntechy.com" || host === "www.blog.cntechy.com" ) {
      return {
        statusCode: 302,
        statusDescription: "Found",
        headers: {
          location: { value: `https://blog.cntechy.com${request.uri}` }
        },
      };
    }
  }
  return event.request;
}