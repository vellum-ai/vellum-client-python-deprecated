# Vellum Python Library

The Vellum python library provides convenient access to the Vellum Predict API from python applications.

## Installation

```bash
$ pip install vellum-client
```

## Usage

### Setup
You'll need an API key from your Vellum account to use this library. You can create an API key from within your account [here](https://app.vellum.ai/api-keys). 
We recommend setting it as an environment variable.

### Generating Text
Here's an example of initializing the library with the API key
loaded from an environment variable and initiating a generation:

```python
import vellum

vellum.api_key = "<YOUR_API_KEY>"

result = vellum.Generate.run(
    deployment_name="my-deployment",
    requests=[
        vellum.GenerateRequest(
            input_values={"question": "Can I get a refund?"}
        )
    ]
)

print(result.text)
```

### Submitting Actuals
Submitting actuals is how you provide feedback to Vellum about the quality of the generated text.
This feedback can be used to measure model quality and improve it over time.

```python
import vellum

vellum.api_key = "<YOUR_API_KEY>"

vellum.SubmitCompletionActuals.run(
    deployment_name="customer-service-demo",
    actuals=[
        vellum.CompletionActual(
            id="<id-returned-from-generate-endpoint>",
            quality=1.0,  # 1.0 is good, 0.0 is bad
            text="Sorry, we do not offer refunds.",
        )
    ]
)
```

**Note:** If you don't want to keep track of the ids that Vellum generates, you can include an externalId key in
the initial generate request. You can then include this externalId when submitting actuals. If you use this
approach, be sure that the ids you provide truly are unique, or you may get unexpected results.


### Uploading Documents to Search Across
Documents can be uploaded to Vellum via either the UI or this API. Once uploaded and indexed,
Vellum's Search allows you to perform semantic searches against them.
Here is an example of how to upload a document from a local file:

```python
import vellum

vellum.api_key = "<YOUR_API_KEY>"


with open("/path/to/your/file.txt", "rb") as file:
    result = vellum.UploadDocument.run(
        # File to upload
        contents=file,
        # Document label
        label="Human-friendly label for your document",
        # The names of indexes that you'd like this document to be added to.
        add_to_index_names=["<your-index-name>"],
        # Optionally include a unique ID from your system to this document later.
        #   Useful if you want to perform updates later
        external_id="<your-index-name>",
        # Optionally include keywords to associate with the document that can be used in hybrid search
        keywords=[],
    )
    
print(result)
```


### Performing a Search
Vellum's Search allows you to upload documents and then perform semantic searches against them.
Here is an example of how to perform a search:

```python
import vellum

vellum.api_key = "<YOUR_API_KEY>"

result = vellum.Search.run(
    index_name="help-center-docs",
    query="What is fine tuning?",
    options=vellum.SearchOptions(limit=3),
)

print(result)
```