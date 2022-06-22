package com.example.crm_sdk_client

import androidx.annotation.NonNull
import com.zoho.crm.sdk.android.api.handler.DataCallback
import com.zoho.crm.sdk.android.api.response.APIResponse
import com.zoho.crm.sdk.android.api.response.BulkAPIResponse
import com.zoho.crm.sdk.android.authorization.ZCRMSDKClient
import com.zoho.crm.sdk.android.common.CommonUtil
import com.zoho.crm.sdk.android.configuration.ZCRMSDKConfigs
import com.zoho.crm.sdk.android.configuration.enableSignUp
import com.zoho.crm.sdk.android.configuration.getBuilder
import com.zoho.crm.sdk.android.crud.ZCRMModule
import com.zoho.crm.sdk.android.crud.ZCRMQuery
import com.zoho.crm.sdk.android.crud.ZCRMRecord
import com.zoho.crm.sdk.android.exception.ZCRMException
import com.zoho.crm.sdk.android.exception.ZCRMLogger
import com.zoho.crm.sdk.android.setup.sdkUtil.ZCRMSDKUtil
import com.zoho.crm.sdk.android.setup.sdkUtil.getModule
import com.zoho.crm.sdk.android.setup.users.ZCRMUser
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception
import java.util.logging.Level

class MainActivity: FlutterActivity() {
    private val channel = "zoho_crm_sdk"
    private val clientID = ""
    private val clientSecret = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
                call, result ->
            when{
                call.method.equals("loginToZohoCRM") -> {
                   loginToZohoCRM(call,result)
                }
            }
            when {
                call.method.equals("checkAuthenticationStatus")->{
                    checkAuthenticationStatus(call,result)
                }
            }
            when {
                call.method.equals("getUserData")->{
                    getUserData(call,result)
                }
            }
            when {
                call.method.equals("getListOfContacts")->{
                    getListOfContacts(call,result)
                }
            }
            when{
                call.method.equals("logout") -> {
                    logout(call,result)
                }
            }
        }
    }

    private fun loginToZohoCRM(call: MethodCall,result: MethodChannel.Result){
        try{
            var sdkConfigs =  ZCRMSDKConfigs.getBuilder(clientID,clientSecret,"ZohoCRM.users.ALL,ZohoCRM.modules.ALL,ZohoCRM.settings.ALL")
                .setHttpRequestMode(CommonUtil.HttpRequestMode.ASYNC).enableSignUp(true)
                .setLoggingPreferences(Level.ALL, true).build()
            ZCRMSDKClient.getInstance(applicationContext)
                .init(sdkConfigs, object : ZCRMSDKClient.Companion.ZCRMInitCallback {
                    override fun onSuccess() {
                        runOnUiThread{
                            result.success(true)
                        }
                    }
                    override fun onFailed(ex: ZCRMException) {
                        runOnUiThread {
                          result.error("401","Invalid Credentials",null)
                        }
                    }

                })
        }catch (e: Exception){
            println(ZCRMLogger.logError(e))
            result.error("401","An Error Occurred",e)
        }

    }

    private fun checkAuthenticationStatus(call: MethodCall,result: MethodChannel.Result) {
        println(ZCRMSDKClient.getInstance(applicationContext).isUserSignedIn())
        result.success(ZCRMSDKClient.getInstance(applicationContext).isUserSignedIn())

    }

    private fun getUserData(call: MethodCall,result: MethodChannel.Result) {
        ZCRMSDKUtil.getCurrentUser(object: DataCallback<APIResponse, ZCRMUser>
        {
            override fun completed(response: APIResponse, user: ZCRMUser)
            {
                println("${response.responseJSON.toString()}")
                result.success(response.responseJSON.getJSONArray("users").getJSONObject(0).toString())
            }

            override fun failed(exception: ZCRMException)
            {
                println("Throws Exception : $exception")
                result.error("401",exception.toString(),null)
            }
        })
    }

    private fun getListOfContacts(call: MethodCall,result: MethodChannel.Result){
        ZCRMSDKUtil.getModule("Contacts",object: DataCallback<APIResponse,ZCRMModule>{
            override fun completed(response: APIResponse, module: ZCRMModule)
            {
                println(module)
               module.getRecords(ZCRMQuery.Companion.GetRecordParams(),object: DataCallback<BulkAPIResponse,List<ZCRMRecord>>{
                   override fun completed(response: BulkAPIResponse, zcrmentity: List<ZCRMRecord>){
                       result.success(response.responseJSON.toString())
                   }

                   override fun failed(exception: ZCRMException)
                   {
                       result.error("401","Throws Exception : $exception",null)
                   }
               })
            }

            override fun failed(exception: ZCRMException)
            {
                println("Throws Exception : $exception")
            }
        })
    }

    private fun logout(call: MethodCall,result: MethodChannel.Result){
        ZCRMSDKClient.getInstance(applicationContext).logout(object : ZCRMSDKClient.Companion.ZCRMLogoutCallback {

            override fun onSuccess() {
                runOnUiThread {
                    result.success(true)
                }
            }

            override fun onFailed(ex: ZCRMException) {
                runOnUiThread {
                    ZCRMLogger.logError("Login failed - $ex")
                    result.error("401",ex.toString(),null)
                }
            }
        })
    }


}
