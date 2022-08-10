
#include "JavaSide.h"
#include "MasterClass.hpp"
#include "HolderClass.hpp"

MasterClass *mcref = NULL;

JNIEXPORT jlong JNICALL Java_JavaSide_getUnderlyingReference(JNIEnv *, jobject) {
	if (mcref == NULL) {
		mcref = new MasterClass("cppcode/MasterClass.hpp");
	}
	HolderClass *hc = mcref->getNextHolder();
	return (jlong)hc;
}
  
JNIEXPORT jstring JNICALL Java_JavaSide_getUnderlyingString(JNIEnv *env, jobject jself, jlong pref) {
	HolderClass *hc = (HolderClass *)pref;
	
	return env->NewStringUTF(hc->getString().c_str());
}