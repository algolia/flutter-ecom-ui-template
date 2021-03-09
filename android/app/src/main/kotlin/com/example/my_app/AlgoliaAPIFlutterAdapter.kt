package com.example.my_app

import android.util.Log
import com.algolia.search.client.ClientSearch
import com.algolia.search.helper.toAPIKey
import com.algolia.search.helper.toApplicationID
import com.algolia.search.helper.toIndexName
import com.algolia.search.model.IndexName
import com.algolia.search.model.response.ResponseSearch
import com.algolia.search.model.search.Query
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.json.Json

class AlgoliaAPIFlutterAdapter(
    applicationID: String,
    apiKey: String,
) {

    private val client = ClientSearch(applicationID.toApplicationID(), apiKey.toAPIKey())

    fun perform(call: MethodCall, result: MethodChannel.Result): Unit = runBlocking {
        Log.d("AlgoliaAPIAdapter", "method: ${call.method}")
        Log.d("AlgoliaAPIAdapter", "args: ${call.arguments}")
        val args = call.arguments as? List<String>
        if (args == null) {
            result.error("AlgoliaNativeError", "Missing arguments", null)
            return@runBlocking
        }

        when (call.method) {
            METHOD_SEARCH -> search(indexName = args[0].toIndexName(), Query(args[1]), result)
            else -> result.notImplemented()
        }
    }

    suspend fun search(indexName: IndexName, query: Query, result: MethodChannel.Result) {
        val index = client.initIndex(indexName)
        try {
            val search = index.search(query = query)
            result.success(Json.encodeToString(ResponseSearch.serializer(), search))
        } catch (e: Exception) {
            result.error("AlgoliaNativeError", e.localizedMessage, e.cause)
        }
    }

    companion object {
        private const val METHOD_SEARCH = "search"
    }
}
