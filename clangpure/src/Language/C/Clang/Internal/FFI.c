
#include "stdlib.h"

#include "clang-c/Index.h"

#include "utils.h"

CXIndex inline_c_Language_C_Clang_Internal_FFI_0_bbb74fcef49f2173e226e50e36672d4cf20c26cf() {
return ( clang_createIndex(0, 1) );
}


int inline_c_Language_C_Clang_Internal_FFI_1_3c515fbd9245ddce5ed6942d9a6d42c942a07e78(CXIndex idxp_inline_c_0, char * cPath_inline_c_1, const char *const* cArgs_inline_c_2, long cArgs_inline_c_3, CXTranslationUnit * tupp_inline_c_4) {
return (
            clang_parseTranslationUnit2(
              idxp_inline_c_0,
              cPath_inline_c_1,
              cArgs_inline_c_2, cArgs_inline_c_3,
              NULL, 0,
              0,
              tupp_inline_c_4)
            );
}


CXCursor * inline_c_Language_C_Clang_Internal_FFI_2_d4ccdcf900c0f4f50805a2755c3c617a64e7224a(CXTranslationUnit tup_inline_c_0) {
return ( ALLOC(
      clang_getTranslationUnitCursor(tup_inline_c_0)
      ));
}


void inline_c_Language_C_Clang_Internal_FFI_3_d722c7ca352b65e2eaeff6a72999a6e9f8b72790(CXCursor * cp_inline_c_0, void (* visitChild_inline_c_1)(CXCursor *)) {

    clang_visitChildren(
      *cp_inline_c_0,
      visit_haskell,
      visitChild_inline_c_1)
    ;
}


const char * inline_c_Language_C_Clang_Internal_FFI_4_f0fd60d11137e5526d0d29649cf6a80152af4ee5(CXString * cxsp_inline_c_0) {
return ( clang_getCString(*cxsp_inline_c_0) );
}


void inline_c_Language_C_Clang_Internal_FFI_5_aaa15c5f7cc155f34bd7888c71f492c421ec921f(CXString * cxsp_inline_c_0) {
 clang_disposeString(*cxsp_inline_c_0) ;
}


void inline_c_Language_C_Clang_Internal_FFI_6_d425edf1274dc3daa35eac5fe1548714ab9e55d1(CXString * cxsp_inline_c_0, CXCursor * cp_inline_c_1) {

    *cxsp_inline_c_0 = clang_getCursorSpelling(*cp_inline_c_1);
    
}


CXSourceRange * inline_c_Language_C_Clang_Internal_FFI_7_1f656c5fcbad4e24f189caebf8a21bd4bd544d1a(CXCursor * cp_inline_c_0) {

    CXSourceRange sr = clang_getCursorExtent(*cp_inline_c_0);
    if (clang_Range_isNull(sr)) {
      return NULL;
    }

    return ALLOC(sr);
    
}


void inline_c_Language_C_Clang_Internal_FFI_8_dbe319fb037e3a9912c9b3007f1effd5915244d4(CXString * cxsp_inline_c_0, CXCursor * cp_inline_c_1) {

    *cxsp_inline_c_0 = clang_getCursorUSR(*cp_inline_c_1);
    
}


CXCursor * inline_c_Language_C_Clang_Internal_FFI_9_3a450acca379512253bb4af9f968b4671c6ab901(CXCursor * cp_inline_c_0) {

    CXCursor ref = clang_getCursorReferenced(*cp_inline_c_0);
    if (clang_Cursor_isNull(ref)) {
      return NULL;
    }

    return ALLOC(ref);
    
}


CXSourceLocation * inline_c_Language_C_Clang_Internal_FFI_10_30e8ba8bd95d9af15d725403d18aef72c0787313(CXSourceRange * srp_inline_c_0) {
return ( ALLOC(
    clang_getRangeStart(*srp_inline_c_0)
    ));
}


CXSourceLocation * inline_c_Language_C_Clang_Internal_FFI_11_3f5cedd5ae9fde896e0cc57f4049e371dc0a02f2(CXSourceRange * srp_inline_c_0) {
return ( ALLOC(
    clang_getRangeEnd(*srp_inline_c_0)
    ));
}


void inline_c_Language_C_Clang_Internal_FFI_12_ed8b5b8c3ef4f245014b16b567c43770a355e76b(CXSourceLocation * slp_inline_c_0, CXFile * fp_inline_c_1, unsigned * lp_inline_c_2, unsigned * cp_inline_c_3, unsigned * offp_inline_c_4) {

      clang_getSpellingLocation(
        *slp_inline_c_0,
        fp_inline_c_1,
        lp_inline_c_2,
        cp_inline_c_3,
        offp_inline_c_4)
      ;
}


CXFile inline_c_Language_C_Clang_Internal_FFI_13_5cf3e853ea71461700b8fd757ace816762a1e2f7(CXTranslationUnit tup_inline_c_0, const char * fn_inline_c_1) {
return (
    clang_getFile(tup_inline_c_0, fn_inline_c_1)
    );
}


void inline_c_Language_C_Clang_Internal_FFI_14_dbcadeb8aae5e46a244b374f4d0f58ce3617a3f7(CXString * cxsp_inline_c_0, CXFile fp_inline_c_1) {

    *cxsp_inline_c_0 = clang_getFileName(fp_inline_c_1);
    
}


CXType * inline_c_Language_C_Clang_Internal_FFI_15_37a0674b73e544d1d767cd2bae4ff0737fd494f3(CXCursor * cp_inline_c_0) {

    CXType type = clang_getCursorType(*cp_inline_c_0);

    if (type.kind == CXType_Invalid) {
      return NULL;
    }

    return ALLOC(type);
    
}


void inline_c_Language_C_Clang_Internal_FFI_16_ea90d6d14f81725ca6b378b32b5f0a8692cb183e(CXString * cxsp_inline_c_0, CXType * tp_inline_c_1) {
 *cxsp_inline_c_0 = clang_getTypeSpelling(*tp_inline_c_1); ;
}


void inline_c_Language_C_Clang_Internal_FFI_17_89c53d60f62a65640c58b0300a6f63e908ff49a3(CXTranslationUnit tup_inline_c_0, CXSourceRange * srp_inline_c_1, CXToken ** tspp_inline_c_2, unsigned * tnp_inline_c_3) {

          clang_tokenize(
            tup_inline_c_0, 
            *srp_inline_c_1,
            tspp_inline_c_2,
            tnp_inline_c_3);
          ;
}


void inline_c_Language_C_Clang_Internal_FFI_18_23fcbc6c0e2bc8f7f35851a4c5875592934558b0(CXString * cxsp_inline_c_0, CXTranslationUnit tup_inline_c_1, CXToken * tp_inline_c_2) {

          *cxsp_inline_c_0 = clang_getTokenSpelling(
            tup_inline_c_1,
            *tp_inline_c_2);
          
}


int inline_c_Language_C_Clang_Internal_FFI_19_9e5e7e97fd800cac78bf653e1e7b41e50cc89260(CXSourceLocation * lp_inline_c_0) {
return (
    clang_Location_isInSystemHeader(*lp_inline_c_0)
    );
}


int inline_c_Language_C_Clang_Internal_FFI_20_ec776d7c2d92b6f9d7bb3abdc61c8411ca22db0f(CXSourceLocation * lp_inline_c_0) {
return (
    clang_Location_isFromMainFile(*lp_inline_c_0)
    );
}


long long inline_c_Language_C_Clang_Internal_FFI_21_66d2d4afcfbed990ca69bc9fbe7633e8036223ae(CXCursor * cp_inline_c_0) {
return ( clang_Cursor_getOffsetOfField(*cp_inline_c_0) );
}


int inline_c_Language_C_Clang_Internal_FFI_22_7c43b31e73b16206ea9c68efab47d1040d99de95(CXType * lp_inline_c_0, CXType * rp_inline_c_1) {
return ( clang_equalTypes(*lp_inline_c_0, *rp_inline_c_1) );
}


int inline_c_Language_C_Clang_Internal_FFI_23_1dc05152878244ed78aba394ab8e0fefccda1dd7(CXSourceLocation * lp_inline_c_0, CXSourceLocation * rp_inline_c_1) {
return ( clang_equalLocations(*lp_inline_c_0, *rp_inline_c_1) );
}


int inline_c_Language_C_Clang_Internal_FFI_24_51cac3d3c6607e337c0c1a424533416af56247d8(CXSourceRange * lp_inline_c_0, CXSourceRange * rp_inline_c_1) {
return ( clang_equalRanges(*lp_inline_c_0, *rp_inline_c_1) );
}


int inline_c_Language_C_Clang_Internal_FFI_25_6edd96afecef70cb0090f782283f6f6a9cf124dc(CXCursor * lp_inline_c_0, CXCursor * rp_inline_c_1) {
return ( clang_equalCursors(*lp_inline_c_0, *rp_inline_c_1) );
}

