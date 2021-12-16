extern (C) {
/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2021, assimp team

All rights reserved.

Redistribution and use of this software in source and binary forms,
with or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of the assimp team, nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of the assimp team.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
*/

/** @file  cimport.h
 *  @brief Defines the C-API to the Open Asset Import Library.
 */

struct aiFileIO;

struct aiMemoryInfo {
    uint textures;
    uint materials;
    uint meshes;
    uint nodes;
    uint animations;
    uint cameras;
    uint lights;
    uint total;
}

struct aiVector2D {
    float x, y;
}

// vector3.h
align(1) struct aiVector3D {
    float x, y, z;
}

align(1) struct aiMatrix3x3 {
    float a1, a2, a3;
    float b1, b2, b3;
    float c1, c2, c3;
}

// matrix4x4.h
struct aiMatrix4x4 {
    float a1, a2, a3, a4;
    float b1, b2, b3, b4;
    float c1, c2, c3, c4;
    float d1, d2, d3, d4;
}

struct aiFace {
    uint mNumIndices;
    uint* mIndices;
}

struct aiVertexWeight {
    uint mVertexId;
    float mWeight;
}

alias aiMetadataType = int;
enum {
    AI_BOOL = 0,
    AI_INT = 1,
    AI_UINT64 = 2,
    AI_FLOAT = 3,
    AI_AISTRING = 4,
    AI_AIVECTOR3D = 5,
}

struct aiMetadataEntry {
    aiMetadataType mType;
    void* mData;
}

struct aiMetadata {
    uint mNumProperties;
    aiString* mKeys;
    aiMetadataEntry* mValues;
}

struct aiNode {
    aiString mName;
    aiMatrix4x4 mTransformation;
    aiNode* mParent;
    uint mNumChildren;
    aiNode** mChildren;
    uint mNumMeshes;
    uint* mMeshes;
    aiMetadata* mMetaData;
}

struct aiQuaternion {
    float w, x, y, z;
}

struct aiBone {
    aiString mName;
    uint mNumWeights;
    aiVertexWeight* mWeights;
    aiMatrix4x4 mOffsetMatrix;
}

enum AI_MAX_FACE_INDICES = 0x7fff;
enum AI_MAX_BONE_WEIGHTS = 0x7fffffff;
enum AI_MAX_VERTICES = 0x7fffffff;
enum AI_MAX_FACES = 0x7fffffff;
enum AI_MAX_NUMBER_OF_COLOR_SETS = 0x8;
enum AI_MAX_NUMBER_OF_TEXTURECOORDS = 0x8;

enum MAXLEN = 1024;

struct aiString {
    size_t length;
    char[MAXLEN] data;
}

// --------------------------------------------------------------------------------
/** C-API: Represents an opaque set of settings to be used during importing.
 *  @see aiCreatePropertyStore
 *  @see aiReleasePropertyStore
 *  @see aiImportFileExWithProperties
 *  @see aiSetPropertyInteger
 *  @see aiSetPropertyFloat
 *  @see aiSetPropertyString
 *  @see aiSetPropertyMatrix
 */
// --------------------------------------------------------------------------------
struct aiPropertyStore {
    char sentinel;
}

// --------------------------------------------------------------------------------
/** Reads the given file and returns its content.
 *
 * If the call succeeds, the imported data is returned in an aiScene structure.
 * The data is intended to be read-only, it stays property of the ASSIMP
 * library and will be stable until aiReleaseImport() is called. After you're
 * done with it, call aiReleaseImport() to free the resources associated with
 * this file. If the import fails, NULL is returned instead. Call
 * aiGetErrorString() to retrieve a human-readable error text.
 * @param pFile Path and filename of the file to be imported,
 *   expected to be a null-terminated c-string. NULL is not a valid value.
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags.
 * @return Pointer to the imported data or NULL if the import failed.
 */
const (aiScene)* aiImportFile(const (char) *pFile, uint pFlags);

// --------------------------------------------------------------------------------
/** Reads the given file using user-defined I/O functions and returns
 *   its content.
 *
 * If the call succeeds, the imported data is returned in an aiScene structure.
 * The data is intended to be read-only, it stays property of the ASSIMP
 * library and will be stable until aiReleaseImport() is called. After you're
 * done with it, call aiReleaseImport() to free the resources associated with
 * this file. If the import fails, NULL is returned instead. Call
 * aiGetErrorString() to retrieve a human-readable error text.
 * @param pFile Path and filename of the file to be imported,
 *   expected to be a null-terminated c-string. NULL is not a valid value.
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags.
 * @param pFS aiFileIO structure. Will be used to open the model file itself
 *   and any other files the loader needs to open.  Pass NULL to use the default
 *   implementation.
 * @return Pointer to the imported data or NULL if the import failed.
 * @note Include <aiFileIO.h> for the definition of #aiFileIO.
 */
const (aiScene) *aiImportFileEx(
        const (char) *pFile,
        uint pFlags,
        aiFileIO *pFS);

// --------------------------------------------------------------------------------
/** Same as #aiImportFileEx, but adds an extra parameter containing importer settings.
 *
 * @param pFile Path and filename of the file to be imported,
 *   expected to be a null-terminated c-string. NULL is not a valid value.
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags.
 * @param pFS aiFileIO structure. Will be used to open the model file itself
 *   and any other files the loader needs to open.  Pass NULL to use the default
 *   implementation.
 * @param pProps #aiPropertyStore instance containing import settings.
 * @return Pointer to the imported data or NULL if the import failed.
 * @note Include <aiFileIO.h> for the definition of #aiFileIO.
 * @see aiImportFileEx
 */
const (aiScene) *aiImportFileExWithProperties(
        const (char) *pFile,
        uint pFlags,
        aiFileIO *pFS,
        const (aiPropertyStore) *pProps);

// --------------------------------------------------------------------------------
/** Reads the given file from a given memory buffer,
 *
 * If the call succeeds, the contents of the file are returned as a pointer to an
 * aiScene object. The returned data is intended to be read-only, the importer keeps
 * ownership of the data and will destroy it upon destruction. If the import fails,
 * NULL is returned.
 * A human-readable error description can be retrieved by calling aiGetErrorString().
 * @param pBuffer Pointer to the file data
 * @param pLength Length of pBuffer, in bytes
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags. If you wish to inspect the imported
 *   scene first in order to fine-tune your post-processing setup,
 *   consider to use #aiApplyPostProcessing().
 * @param pHint An additional hint to the library. If this is a non empty string,
 *   the library looks for a loader to support the file extension specified by pHint
 *   and passes the file to the first matching loader. If this loader is unable to
 *   completely the request, the library continues and tries to determine the file
 *   format on its own, a task that may or may not be successful.
 *   Check the return value, and you'll know ...
 * @return A pointer to the imported data, NULL if the import failed.
 *
 * @note This is a straightforward way to decode models from memory
 * buffers, but it doesn't handle model formats that spread their
 * data across multiple files or even directories. Examples include
 * OBJ or MD3, which outsource parts of their material info into
 * external scripts. If you need full functionality, provide
 * a custom IOSystem to make Assimp find these files and use
 * the regular aiImportFileEx()/aiImportFileExWithProperties() API.
 */
const (aiScene) *aiImportFileFromMemory(
        const (char) *pBuffer,
        uint pLength,
        uint pFlags,
        const (char) *pHint);

// --------------------------------------------------------------------------------
/** Same as #aiImportFileFromMemory, but adds an extra parameter containing importer settings.
 *
 * @param pBuffer Pointer to the file data
 * @param pLength Length of pBuffer, in bytes
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags. If you wish to inspect the imported
 *   scene first in order to fine-tune your post-processing setup,
 *   consider to use #aiApplyPostProcessing().
 * @param pHint An additional hint to the library. If this is a non empty string,
 *   the library looks for a loader to support the file extension specified by pHint
 *   and passes the file to the first matching loader. If this loader is unable to
 *   completely the request, the library continues and tries to determine the file
 *   format on its own, a task that may or may not be successful.
 *   Check the return value, and you'll know ...
 * @param pProps #aiPropertyStore instance containing import settings.
 * @return A pointer to the imported data, NULL if the import failed.
 *
 * @note This is a straightforward way to decode models from memory
 * buffers, but it doesn't handle model formats that spread their
 * data across multiple files or even directories. Examples include
 * OBJ or MD3, which outsource parts of their material info into
 * external scripts. If you need full functionality, provide
 * a custom IOSystem to make Assimp find these files and use
 * the regular aiImportFileEx()/aiImportFileExWithProperties() API.
 * @see aiImportFileFromMemory
 */
const (aiScene) *aiImportFileFromMemoryWithProperties(
        const (char) *pBuffer,
        uint pLength,
        uint pFlags,
        const (char) *pHint,
        const (aiPropertyStore) *pProps);

// --------------------------------------------------------------------------------
/** Apply post-processing to an already-imported scene.
 *
 * This is strictly equivalent to calling #aiImportFile()/#aiImportFileEx with the
 * same flags. However, you can use this separate function to inspect the imported
 * scene first to fine-tune your post-processing setup.
 * @param pScene Scene to work on.
 * @param pFlags Provide a bitwise combination of the #aiPostProcessSteps flags.
 * @return A pointer to the post-processed data. Post processing is done in-place,
 *   meaning this is still the same #aiScene which you passed for pScene. However,
 *   _if_ post-processing failed, the scene could now be NULL. That's quite a rare
 *   case, post processing steps are not really designed to 'fail'. To be exact,
 *   the #aiProcess_ValidateDataStructure flag is currently the only post processing step
 *   which can actually cause the scene to be reset to NULL.
 */
const (aiScene) *aiApplyPostProcessing(
        const (aiScene) *pScene,
        uint pFlags);

// --------------------------------------------------------------------------------
/** Releases all resources associated with the given import process.
 *
 * Call this function after you're done with the imported data.
 * @param pScene The imported data to release. NULL is a valid value.
 */
void aiReleaseImport(
        const (aiScene) *pScene);

// --------------------------------------------------------------------------------
/** Returns the error text of the last failed import process.
 *
 * @return A textual description of the error that occurred at the last
 * import process. NULL if there was no error. There can't be an error if you
 * got a non-NULL #aiScene from #aiImportFile/#aiImportFileEx/#aiApplyPostProcessing.
 */
const (char) *aiGetErrorString();

// --------------------------------------------------------------------------------
/** Returns whether a given file extension is supported by ASSIMP
 *
 * @param szExtension Extension for which the function queries support for.
 * Must include a leading dot '.'. Example: ".3ds", ".md3"
 * @return AI_TRUE if the file extension is supported.
 */
int aiIsExtensionSupported(const (char) *szExtension);

// --------------------------------------------------------------------------------
/** Get a list of all file extensions supported by ASSIMP.
 *
 * If a file extension is contained in the list this does, of course, not
 * mean that ASSIMP is able to load all files with this extension.
 * @param szOut String to receive the extension list.
 * Format of the list: "*.3ds;*.obj;*.dae". NULL is not a valid parameter.
 */
void aiGetExtensionList(
        aiString *szOut);

// --------------------------------------------------------------------------------
/** Get the approximated storage required by an imported asset
 * @param pIn Input asset.
 * @param in Data structure to be filled.
 */
void aiGetMemoryRequirements(
        const (aiScene) *pIn,
        aiMemoryInfo * info);

// --------------------------------------------------------------------------------
/** Create an empty property store. Property stores are used to collect import
 *  settings.
 * @return New property store. Property stores need to be manually destroyed using
 *   the #aiReleasePropertyStore API function.
 */
aiPropertyStore *aiCreatePropertyStore();

// --------------------------------------------------------------------------------
/** Delete a property store.
 * @param p Property store to be deleted.
 */
void aiReleasePropertyStore(aiPropertyStore *p);

// --------------------------------------------------------------------------------
/** Set an integer property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyInteger(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param value New value for the property
 */
void aiSetImportPropertyInteger(
        aiPropertyStore *store,
        const (char) *szName,
        int value);

// --------------------------------------------------------------------------------
/** Set a floating-point property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyFloat(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param value New value for the property
 */
void aiSetImportPropertyFloat(
        aiPropertyStore *store,
        const (char) *szName,
        float value);

// --------------------------------------------------------------------------------
/** Set a string property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyString(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param st New value for the property
 */
void aiSetImportPropertyString(
        aiPropertyStore *store,
        const (char) *szName,
        const (aiString) *st);

// --------------------------------------------------------------------------------
/** Set a matrix property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyMatrix(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param mat New value for the property
 */
void aiSetImportPropertyMatrix(
        aiPropertyStore *store,
        const (char) *szName,
        const (aiMatrix4x4) *mat);

// --------------------------------------------------------------------------------
/** Construct a quaternion from a 3x3 rotation matrix.
 *  @param quat Receives the output quaternion.
 *  @param mat Matrix to 'quaternionize'.
 *  @see aiQuaternion(const aiMatrix3x3& pRotMatrix)
 */
void aiCreateQuaternionFromMatrix(
        aiQuaternion *quat,
        const (aiMatrix3x3) *mat);

// --------------------------------------------------------------------------------
/** Decompose a transformation matrix into its rotational, translational and
 *  scaling components.
 *
 * @param mat Matrix to decompose
 * @param scaling Receives the scaling component
 * @param rotation Receives the rotational component
 * @param position Receives the translational component.
 * @see aiMatrix4x4::Decompose (aiVector3D&, aiQuaternion&, aiVector3D&) const;
 */
void aiDecomposeMatrix(
        const (aiMatrix4x4) *mat,
        aiVector3D *scaling,
        aiQuaternion *rotation,
        aiVector3D *position);

// --------------------------------------------------------------------------------
/** Transpose a 4x4 matrix.
 *  @param mat Pointer to the matrix to be transposed
 */
void aiTransposeMatrix4(
        aiMatrix4x4 *mat);

// --------------------------------------------------------------------------------
/** Transpose a 3x3 matrix.
 *  @param mat Pointer to the matrix to be transposed
 */
void aiTransposeMatrix3(
        aiMatrix3x3 *mat);

// --------------------------------------------------------------------------------
/** Transform a vector by a 3x3 matrix
 *  @param vec Vector to be transformed.
 *  @param mat Matrix to transform the vector with.
 */
void aiTransformVecByMatrix3(
        aiVector3D *vec,
        const (aiMatrix3x3) *mat);

// --------------------------------------------------------------------------------
/** Transform a vector by a 4x4 matrix
 *  @param vec Vector to be transformed.
 *  @param mat Matrix to transform the vector with.
 */
void aiTransformVecByMatrix4(
        aiVector3D *vec,
        const (aiMatrix4x4) *mat);

// --------------------------------------------------------------------------------
/** Multiply two 4x4 matrices.
 *  @param dst First factor, receives result.
 *  @param src Matrix to be multiplied with 'dst'.
 */
void aiMultiplyMatrix4(
        aiMatrix4x4 *dst,
        const (aiMatrix4x4) *src);

// --------------------------------------------------------------------------------
/** Multiply two 3x3 matrices.
 *  @param dst First factor, receives result.
 *  @param src Matrix to be multiplied with 'dst'.
 */
void aiMultiplyMatrix3(
        aiMatrix3x3 *dst,
        const (aiMatrix3x3) *src);

// --------------------------------------------------------------------------------
/** Get a 3x3 identity matrix.
 *  @param mat Matrix to receive its personal identity
 */
void aiIdentityMatrix3(
        aiMatrix3x3 *mat);

// --------------------------------------------------------------------------------
/** Get a 4x4 identity matrix.
 *  @param mat Matrix to receive its personal identity
 */
void aiIdentityMatrix4(
        aiMatrix4x4 *mat);

// --------------------------------------------------------------------------------
/** Returns the number of import file formats available in the current Assimp build.
 * Use aiGetImportFormatDescription() to retrieve infos of a specific import format.
 */
size_t aiGetImportFormatCount();

// --------------------------------------------------------------------------------
/** Returns a description of the nth import file format. Use #aiGetImportFormatCount()
 * to learn how many import formats are supported.
 * @param pIndex Index of the import format to retrieve information for. Valid range is
 *    0 to #aiGetImportFormatCount()
 * @return A description of that specific import format. NULL if pIndex is out of range.
 */
const (aiImporterDesc) *aiGetImportFormatDescription(size_t pIndex);

struct aiImporterDesc {
    const(char)* mName;
    const(char)* mAuthor;
    const(char)* mMaintainer;
    const(char)* mComments;
    uint mFlags;
    uint mMinMajor;
    uint mMinMinor;
    uint mMaxMajor;
    uint mMaxMinor;
    const(char)* mFileExtensions;
}

// --------------------------------------------------------------------------------
/** Check if 2D vectors are equal.
 *  @param a First vector to compare
 *  @param b Second vector to compare
 *  @return 1 if the vectors are equal
 *  @return 0 if the vectors are not equal
 */
int aiVector2AreEqual(
        const (aiVector2D) *a,
        const (aiVector2D) *b);

// --------------------------------------------------------------------------------
/** Check if 2D vectors are equal using epsilon.
 *  @param a First vector to compare
 *  @param b Second vector to compare
 *  @param epsilon Epsilon
 *  @return 1 if the vectors are equal
 *  @return 0 if the vectors are not equal
 */
int aiVector2AreEqualEpsilon(
        const (aiVector2D) *a,
        const (aiVector2D) *b,
        const (float) epsilon);

// --------------------------------------------------------------------------------
/** Add 2D vectors.
 *  @param dst First addend, receives result.
 *  @param src Vector to be added to 'dst'.
 */
void aiVector2Add(
        aiVector2D *dst,
        const (aiVector2D) *src);

// --------------------------------------------------------------------------------
/** Subtract 2D vectors.
 *  @param dst Minuend, receives result.
 *  @param src Vector to be subtracted from 'dst'.
 */
void aiVector2Subtract(
        aiVector2D *dst,
        const (aiVector2D) *src);

// --------------------------------------------------------------------------------
/** Multiply a 2D vector by a scalar.
 *  @param dst Vector to be scaled by \p s
 *  @param s Scale factor
 */
void aiVector2Scale(
        aiVector2D *dst,
        const (float) s);

// --------------------------------------------------------------------------------
/** Multiply each component of a 2D vector with
 *  the components of another vector.
 *  @param dst First vector, receives result
 *  @param other Second vector
 */
void aiVector2SymMul(
        aiVector2D *dst,
        const (aiVector2D) *other);

// --------------------------------------------------------------------------------
/** Divide a 2D vector by a scalar.
 *  @param dst Vector to be divided by \p s
 *  @param s Scalar divisor
 */
void aiVector2DivideByScalar(
        aiVector2D *dst,
        const (float) s);

// --------------------------------------------------------------------------------
/** Divide each component of a 2D vector by
 *  the components of another vector.
 *  @param dst Vector as the dividend
 *  @param v Vector as the divisor
 */
void aiVector2DivideByVector(
        aiVector2D *dst,
        aiVector2D *v);

// --------------------------------------------------------------------------------
/** Get the length of a 2D vector.
 *  @return v Vector to evaluate
 */
float aiVector2Length(
        const (aiVector2D) *v);

// --------------------------------------------------------------------------------
/** Get the squared length of a 2D vector.
 *  @return v Vector to evaluate
 */
float aiVector2SquareLength(
        const (aiVector2D) *v);

// --------------------------------------------------------------------------------
/** Negate a 2D vector.
 *  @param dst Vector to be negated
 */
void aiVector2Negate(
        aiVector2D *dst);

// --------------------------------------------------------------------------------
/** Get the dot product of 2D vectors.
 *  @param a First vector
 *  @param b Second vector
 *  @return The dot product of vectors
 */
float aiVector2DotProduct(
        const (aiVector2D) *a,
        const (aiVector2D) *b);

// --------------------------------------------------------------------------------
/** Normalize a 2D vector.
 *  @param v Vector to normalize
 */
void aiVector2Normalize(
        aiVector2D *v);

// --------------------------------------------------------------------------------
/** Check if 3D vectors are equal.
 *  @param a First vector to compare
 *  @param b Second vector to compare
 *  @return 1 if the vectors are equal
 *  @return 0 if the vectors are not equal
 */
int aiVector3AreEqual(
        const (aiVector3D) *a,
        const (aiVector3D) *b);

// --------------------------------------------------------------------------------
/** Check if 3D vectors are equal using epsilon.
 *  @param a First vector to compare
 *  @param b Second vector to compare
 *  @param epsilon Epsilon
 *  @return 1 if the vectors are equal
 *  @return 0 if the vectors are not equal
 */
int aiVector3AreEqualEpsilon(
        const (aiVector3D) *a,
        const (aiVector3D) *b,
        const (float) epsilon);

// --------------------------------------------------------------------------------
/** Check if vector \p a is less than vector \p b.
 *  @param a First vector to compare
 *  @param b Second vector to compare
 *  @param epsilon Epsilon
 *  @return 1 if \p a is less than \p b
 *  @return 0 if \p a is equal or greater than \p b
 */
int aiVector3LessThan(
        const (aiVector3D) *a,
        const (aiVector3D) *b);

// --------------------------------------------------------------------------------
/** Add 3D vectors.
 *  @param dst First addend, receives result.
 *  @param src Vector to be added to 'dst'.
 */
void aiVector3Add(
        aiVector3D *dst,
        const (aiVector3D) *src);

// --------------------------------------------------------------------------------
/** Subtract 3D vectors.
 *  @param dst Minuend, receives result.
 *  @param src Vector to be subtracted from 'dst'.
 */
void aiVector3Subtract(
        aiVector3D *dst,
        const (aiVector3D) *src);

// --------------------------------------------------------------------------------
/** Multiply a 3D vector by a scalar.
 *  @param dst Vector to be scaled by \p s
 *  @param s Scale factor
 */
void aiVector3Scale(
        aiVector3D *dst,
        const (float) s);

// --------------------------------------------------------------------------------
/** Multiply each component of a 3D vector with
 *  the components of another vector.
 *  @param dst First vector, receives result
 *  @param other Second vector
 */
void aiVector3SymMul(
        aiVector3D *dst,
        const (aiVector3D) *other);

// --------------------------------------------------------------------------------
/** Divide a 3D vector by a scalar.
 *  @param dst Vector to be divided by \p s
 *  @param s Scalar divisor
 */
void aiVector3DivideByScalar(
        aiVector3D *dst,
        const (float) s);

// --------------------------------------------------------------------------------
/** Divide each component of a 3D vector by
 *  the components of another vector.
 *  @param dst Vector as the dividend
 *  @param v Vector as the divisor
 */
void aiVector3DivideByVector(
        aiVector3D *dst,
        aiVector3D *v);

// --------------------------------------------------------------------------------
/** Get the length of a 3D vector.
 *  @return v Vector to evaluate
 */
float aiVector3Length(
        const (aiVector3D) *v);

// --------------------------------------------------------------------------------
/** Get the squared length of a 3D vector.
 *  @return v Vector to evaluate
 */
float aiVector3SquareLength(
        const (aiVector3D) *v);

// --------------------------------------------------------------------------------
/** Negate a 3D vector.
 *  @param dst Vector to be negated
 */
void aiVector3Negate(
        aiVector3D *dst);

// --------------------------------------------------------------------------------
/** Get the dot product of 3D vectors.
 *  @param a First vector
 *  @param b Second vector
 *  @return The dot product of vectors
 */
float aiVector3DotProduct(
        const (aiVector3D) *a,
        const (aiVector3D) *b);

// --------------------------------------------------------------------------------
/** Get cross product of 3D vectors.
 *  @param dst Vector to receive the result.
 *  @param a First vector
 *  @param b Second vector
 *  @return The dot product of vectors
 */
void aiVector3CrossProduct(
        aiVector3D *dst,
        const (aiVector3D) *a,
        const (aiVector3D) *b);

// --------------------------------------------------------------------------------
/** Normalize a 3D vector.
 *  @param v Vector to normalize
 */
void aiVector3Normalize(
        aiVector3D *v);

// --------------------------------------------------------------------------------
/** Check for division by zero and normalize a 3D vector.
 *  @param v Vector to normalize
 */
void aiVector3NormalizeSafe(
        aiVector3D *v);

// --------------------------------------------------------------------------------
/** Rotate a 3D vector by a quaternion.
 *  @param v The vector to rotate by \p q
 *  @param q Quaternion to use to rotate \p v
 */
void aiVector3RotateByQuaternion(
        aiVector3D *v,
        const (aiQuaternion) *q);

// --------------------------------------------------------------------------------
/** Construct (a 3x3) matrix from a 4x4 matrix.
 *  @param dst Receives the output matrix
 *  @param mat The 4x4 matrix to use
 */
void aiMatrix3FromMatrix4(
        aiMatrix3x3 *dst,
        const (aiMatrix4x4) *mat);

// --------------------------------------------------------------------------------
/** Construct (a 3x3) matrix from a quaternion.
 *  @param mat Receives the output matrix
 *  @param q The quaternion matrix to use
 */
void aiMatrix3FromQuaternion(
        aiMatrix3x3 *mat,
        const (aiQuaternion) *q);

// --------------------------------------------------------------------------------
/** Check if 3x3 matrices are equal.
 *  @param a First matrix to compare
 *  @param b Second matrix to compare
 *  @return 1 if the matrices are equal
 *  @return 0 if the matrices are not equal
 */
int aiMatrix3AreEqual(
        const aiMatrix3x3 *a,
        const aiMatrix3x3 *b);

// --------------------------------------------------------------------------------
/** Check if 3x3 matrices are equal.
 *  @param a First matrix to compare
 *  @param b Second matrix to compare
 *  @param epsilon Epsilon
 *  @return 1 if the matrices are equal
 *  @return 0 if the matrices are not equal
 */
int aiMatrix3AreEqualEpsilon(
        const aiMatrix3x3 *a,
        const aiMatrix3x3 *b,
        const float epsilon);

// --------------------------------------------------------------------------------
/** Invert a 3x3 matrix.
 *  @param mat Matrix to invert
 */
void aiMatrix3Inverse(
        aiMatrix3x3 *mat);

// --------------------------------------------------------------------------------
/** Get the determinant of a 3x3 matrix.
 *  @param mat Matrix to get the determinant from
 */
float aiMatrix3Determinant(
        const aiMatrix3x3 *mat);

// --------------------------------------------------------------------------------
/** Get a 3x3 rotation matrix around the Z axis.
 *  @param mat Receives the output matrix
 *  @param angle Rotation angle, in radians
 */
void aiMatrix3RotationZ(
        aiMatrix3x3 *mat,
        const float angle);

// --------------------------------------------------------------------------------
/** Returns a 3x3 rotation matrix for a rotation around an arbitrary axis.
 *  @param mat Receives the output matrix
 *  @param axis Rotation axis, should be a normalized vector
 *  @param angle Rotation angle, in radians
 */
void aiMatrix3FromRotationAroundAxis(
        aiMatrix3x3 *mat,
        const aiVector3D *axis,
        const float angle);

// --------------------------------------------------------------------------------
/** Get a 3x3 translation matrix.
 *  @param mat Receives the output matrix
 *  @param translation The translation vector
 */
void aiMatrix3Translation(
        aiMatrix3x3 *mat,
        const aiVector2D *translation);

// --------------------------------------------------------------------------------
/** Create a 3x3 matrix that rotates one vector to another vector.
 *  @param mat Receives the output matrix
 *  @param from Vector to rotate from
 *  @param to Vector to rotate to
 */
void aiMatrix3FromTo(
        aiMatrix3x3 *mat,
        const aiVector3D *from,
        const aiVector3D *to);

// --------------------------------------------------------------------------------
/** Construct a 4x4 matrix from a 3x3 matrix.
 *  @param dst Receives the output matrix
 *  @param mat The 3x3 matrix to use
 */
void aiMatrix4FromMatrix3(
        aiMatrix4x4 *dst,
        const aiMatrix3x3 *mat);

// --------------------------------------------------------------------------------
/** Construct a 4x4 matrix from scaling, rotation and position.
 *  @param mat Receives the output matrix.
 *  @param scaling The scaling for the x,y,z axes
 *  @param rotation The rotation as a hamilton quaternion
 *  @param position The position for the x,y,z axes
 */
void aiMatrix4FromScalingQuaternionPosition(
        aiMatrix4x4 *mat,
        const aiVector3D *scaling,
        const aiQuaternion *rotation,
        const aiVector3D *position);

// --------------------------------------------------------------------------------
/** Add 4x4 matrices.
 *  @param dst First addend, receives result.
 *  @param src Matrix to be added to 'dst'.
 */
void aiMatrix4Add(
        aiMatrix4x4 *dst,
        const aiMatrix4x4 *src);

// --------------------------------------------------------------------------------
/** Check if 4x4 matrices are equal.
 *  @param a First matrix to compare
 *  @param b Second matrix to compare
 *  @return 1 if the matrices are equal
 *  @return 0 if the matrices are not equal
 */
int aiMatrix4AreEqual(
        const aiMatrix4x4 *a,
        const aiMatrix4x4 *b);

// --------------------------------------------------------------------------------
/** Check if 4x4 matrices are equal.
 *  @param a First matrix to compare
 *  @param b Second matrix to compare
 *  @param epsilon Epsilon
 *  @return 1 if the matrices are equal
 *  @return 0 if the matrices are not equal
 */
int aiMatrix4AreEqualEpsilon(
        const aiMatrix4x4 *a,
        const aiMatrix4x4 *b,
        const float epsilon);

// --------------------------------------------------------------------------------
/** Invert a 4x4 matrix.
 *  @param result Matrix to invert
 */
void aiMatrix4Inverse(
        aiMatrix4x4 *mat);

// --------------------------------------------------------------------------------
/** Get the determinant of a 4x4 matrix.
 *  @param mat Matrix to get the determinant from
 *  @return The determinant of the matrix
 */
float aiMatrix4Determinant(
        const aiMatrix4x4 *mat);

// --------------------------------------------------------------------------------
/** Returns true of the matrix is the identity matrix.
 *  @param mat Matrix to get the determinant from
 *  @return 1 if \p mat is an identity matrix.
 *  @return 0 if \p mat is not an identity matrix.
 */
int aiMatrix4IsIdentity(
        const aiMatrix4x4 *mat);

// --------------------------------------------------------------------------------
/** Decompose a transformation matrix into its scaling,
 *  rotational as euler angles, and translational components.
 *
 * @param mat Matrix to decompose
 * @param scaling Receives the output scaling for the x,y,z axes
 * @param rotation Receives the output rotation as a Euler angles
 * @param position Receives the output position for the x,y,z axes
 */
void aiMatrix4DecomposeIntoScalingEulerAnglesPosition(
        const aiMatrix4x4 *mat,
        aiVector3D *scaling,
        aiVector3D *rotation,
        aiVector3D *position);

// --------------------------------------------------------------------------------
/** Decompose a transformation matrix into its scaling,
 *  rotational split into an axis and rotational angle,
 *  and it's translational components.
 *
 * @param mat Matrix to decompose
 * @param rotation Receives the rotational component
 * @param axis Receives the output rotation axis
 * @param angle Receives the output rotation angle
 * @param position Receives the output position for the x,y,z axes.
 */
void aiMatrix4DecomposeIntoScalingAxisAnglePosition(
        const aiMatrix4x4 *mat,
        aiVector3D *scaling,
        aiVector3D *axis,
        float *angle,
        aiVector3D *position);

// --------------------------------------------------------------------------------
/** Decompose a transformation matrix into its rotational and
 *  translational components.
 *
 * @param mat Matrix to decompose
 * @param rotation Receives the rotational component
 * @param position Receives the translational component.
 */
void aiMatrix4DecomposeNoScaling(
        const aiMatrix4x4 *mat,
        aiQuaternion *rotation,
        aiVector3D *position);

// --------------------------------------------------------------------------------
/** Creates a 4x4 matrix from a set of euler angles.
 *  @param mat Receives the output matrix
 *  @param x Rotation angle for the x-axis, in radians
 *  @param y Rotation angle for the y-axis, in radians
 *  @param z Rotation angle for the z-axis, in radians
 */
void aiMatrix4FromEulerAngles(
        aiMatrix4x4 *mat,
        float x, float y, float z);

// --------------------------------------------------------------------------------
/** Get a 4x4 rotation matrix around the X axis.
 *  @param mat Receives the output matrix
 *  @param angle Rotation angle, in radians
 */
void aiMatrix4RotationX(
        aiMatrix4x4 *mat,
        const float angle);

// --------------------------------------------------------------------------------
/** Get a 4x4 rotation matrix around the Y axis.
 *  @param mat Receives the output matrix
 *  @param angle Rotation angle, in radians
 */
void aiMatrix4RotationY(
        aiMatrix4x4 *mat,
        const float angle);

// --------------------------------------------------------------------------------
/** Get a 4x4 rotation matrix around the Z axis.
 *  @param mat Receives the output matrix
 *  @param angle Rotation angle, in radians
 */
void aiMatrix4RotationZ(
        aiMatrix4x4 *mat,
        const float angle);

// --------------------------------------------------------------------------------
/** Returns a 4x4 rotation matrix for a rotation around an arbitrary axis.
 *  @param mat Receives the output matrix
 *  @param axis Rotation axis, should be a normalized vector
 *  @param angle Rotation angle, in radians
 */
void aiMatrix4FromRotationAroundAxis(
        aiMatrix4x4 *mat,
        const aiVector3D *axis,
        const float angle);

// --------------------------------------------------------------------------------
/** Get a 4x4 translation matrix.
 *  @param mat Receives the output matrix
 *  @param translation The translation vector
 */
void aiMatrix4Translation(
        aiMatrix4x4 *mat,
        const aiVector3D *translation);

// --------------------------------------------------------------------------------
/** Get a 4x4 scaling matrix.
 *  @param mat Receives the output matrix
 *  @param scaling The scaling vector
 */
void aiMatrix4Scaling(
        aiMatrix4x4 *mat,
        const aiVector3D *scaling);

// --------------------------------------------------------------------------------
/** Create a 4x4 matrix that rotates one vector to another vector.
 *  @param mat Receives the output matrix
 *  @param from Vector to rotate from
 *  @param to Vector to rotate to
 */
void aiMatrix4FromTo(
        aiMatrix4x4 *mat,
        const aiVector3D *from,
        const aiVector3D *to);

// --------------------------------------------------------------------------------
/** Create a Quaternion from euler angles.
 *  @param q Receives the output quaternion
 *  @param x Rotation angle for the x-axis, in radians
 *  @param y Rotation angle for the y-axis, in radians
 *  @param z Rotation angle for the z-axis, in radians
 */
void aiQuaternionFromEulerAngles(
        aiQuaternion *q,
        float x, float y, float z);

// --------------------------------------------------------------------------------
/** Create a Quaternion from an axis angle pair.
 *  @param q Receives the output quaternion
 *  @param axis The orientation axis
 *  @param angle The rotation angle, in radians
 */
void aiQuaternionFromAxisAngle(
        aiQuaternion *q,
        const aiVector3D *axis,
        const float angle);

// --------------------------------------------------------------------------------
/** Create a Quaternion from a normalized quaternion stored
 *  in a 3D vector.
 *  @param q Receives the output quaternion
 *  @param normalized The vector that stores the quaternion
 */
void aiQuaternionFromNormalizedQuaternion(
        aiQuaternion *q,
        const aiVector3D *normalized);

// --------------------------------------------------------------------------------
/** Check if quaternions are equal.
 *  @param a First quaternion to compare
 *  @param b Second quaternion to compare
 *  @return 1 if the quaternions are equal
 *  @return 0 if the quaternions are not equal
 */
int aiQuaternionAreEqual(
        const aiQuaternion *a,
        const aiQuaternion *b);

// --------------------------------------------------------------------------------
/** Check if quaternions are equal using epsilon.
 *  @param a First quaternion to compare
 *  @param b Second quaternion to compare
 *  @param epsilon Epsilon
 *  @return 1 if the quaternions are equal
 *  @return 0 if the quaternions are not equal
 */
int aiQuaternionAreEqualEpsilon(
        const aiQuaternion *a,
        const aiQuaternion *b,
        const float epsilon);

// --------------------------------------------------------------------------------
/** Normalize a quaternion.
 *  @param q Quaternion to normalize
 */
void aiQuaternionNormalize(
        aiQuaternion *q);

// --------------------------------------------------------------------------------
/** Compute quaternion conjugate.
 *  @param q Quaternion to compute conjugate,
 *           receives the output quaternion
 */
void aiQuaternionConjugate(
        aiQuaternion *q);

// --------------------------------------------------------------------------------
/** Multiply quaternions.
 *  @param dst First quaternion, receives the output quaternion
 *  @param q Second quaternion
 */
void aiQuaternionMultiply(
        aiQuaternion *dst,
        const aiQuaternion *q);

// --------------------------------------------------------------------------------
/** Performs a spherical interpolation between two quaternions.
 * @param dst Receives the quaternion resulting from the interpolation.
 * @param start Quaternion when factor == 0
 * @param end Quaternion when factor == 1
 * @param factor Interpolation factor between 0 and 1
 */
void aiQuaternionInterpolate(
        aiQuaternion *dst,
        const aiQuaternion *start,
        const aiQuaternion *end,
        const float factor);

struct aiScene
{
    /** Any combination of the AI_SCENE_FLAGS_XXX flags. By default
    * this value is 0, no flags are set. Most applications will
    * want to reject all scenes with the AI_SCENE_FLAGS_INCOMPLETE
    * bit set.
    */
    uint mFlags;

    /** The root node of the hierarchy.
    *
    * There will always be at least the root node if the import
    * was successful (and no special flags have been set).
    * Presence of further nodes depends on the format and content
    * of the imported file.
    */
    aiNode* mRootNode;

    /** The number of meshes in the scene. */
    uint mNumMeshes;

    /** The array of meshes.
    *
    * Use the indices given in the aiNode structure to access
    * this array. The array is mNumMeshes in size. If the
    * AI_SCENE_FLAGS_INCOMPLETE flag is not set there will always
    * be at least ONE material.
    */
    aiMesh** mMeshes;

    /** The number of materials in the scene. */
    uint mNumMaterials;

    /** The array of materials.
    *
    * Use the index given in each aiMesh structure to access this
    * array. The array is mNumMaterials in size. If the
    * AI_SCENE_FLAGS_INCOMPLETE flag is not set there will always
    * be at least ONE material.
    */
    aiMaterial** mMaterials;

    /** The number of animations in the scene. */
    uint mNumAnimations;

    /** The array of animations.
    *
    * All animations imported from the given file are listed here.
    * The array is mNumAnimations in size.
    */
    aiAnimation** mAnimations;

    /** The number of textures embedded into the file */
    uint mNumTextures;

    /** The array of embedded textures.
    *
    * Not many file formats embed their textures into the file.
    * An example is Quake's MDL format (which is also used by
    * some GameStudio versions)
    */
    aiTexture** mTextures;

    /** The number of light sources in the scene. Light sources
    * are fully optional, in most cases this attribute will be 0
        */
    uint mNumLights;

    /** The array of light sources.
    *
    * All light sources imported from the given file are
    * listed here. The array is mNumLights in size.
    */
    aiLight** mLights;

    /** The number of cameras in the scene. Cameras
    * are fully optional, in most cases this attribute will be 0
        */
    uint mNumCameras;

    /** The array of cameras.
    *
    * All cameras imported from the given file are listed here.
    * The array is mNumCameras in size. The first camera in the
    * array (if existing) is the default camera view into
    * the scene.
    */
    aiCamera** mCameras;

    /**
     *  @brief  The global metadata assigned to the scene itself.
     *
     *  This data contains global metadata which belongs to the scene like
     *  unit-conversions, versions, vendors or other model-specific data. This
     *  can be used to store format-specific metadata as well.
     */
    aiMetadata* mMetaData;

    /** The name of the scene itself.
     */
    aiString mName;

    char* mPrivate;
};

struct aiMesh {
    /** Bitwise combination of the members of the #aiPrimitiveType enum.
     * This specifies which types of primitives are present in the mesh.
     * The "SortByPrimitiveType"-Step can be used to make sure the
     * output meshes consist of one primitive type each.
     */
    uint mPrimitiveTypes;

    /** The number of vertices in this mesh.
    * This is also the size of all of the per-vertex data arrays.
    * The maximum value for this member is #AI_MAX_VERTICES.
    */
    uint mNumVertices;

    /** The number of primitives (triangles, polygons, lines) in this  mesh.
    * This is also the size of the mFaces array.
    * The maximum value for this member is #AI_MAX_FACES.
    */
    uint mNumFaces;

    /** Vertex positions.
    * This array is always present in a mesh. The array is
    * mNumVertices in size.
    */
    aiVector3D *mVertices;

    /** Vertex normals.
    * The array contains normalized vectors, nullptr if not present.
    * The array is mNumVertices in size. Normals are undefined for
    * point and line primitives. A mesh consisting of points and
    * lines only may not have normal vectors. Meshes with mixed
    * primitive types (i.e. lines and triangles) may have normals,
    * but the normals for vertices that are only referenced by
    * point or line primitives are undefined and set to QNaN (WARN:
    * qNaN compares to inequal to *everything*, even to qNaN itself.
    * Using code like this to check whether a field is qnan is:
    * @code
    * #define IS_QNAN(f) (f != f)
    * @endcode
    * still dangerous because even 1.f == 1.f could evaluate to false! (
    * remember the subtleties of IEEE754 artithmetics). Use stuff like
    * @c fpclassify instead.
    * @note Normal vectors computed by Assimp are always unit-length.
    * However, this needn't apply for normals that have been taken
    *   directly from the model file.
    */
    aiVector3D *mNormals;

    /** Vertex tangents.
    * The tangent of a vertex points in the direction of the positive
    * X texture axis. The array contains normalized vectors, nullptr if
    * not present. The array is mNumVertices in size. A mesh consisting
    * of points and lines only may not have normal vectors. Meshes with
    * mixed primitive types (i.e. lines and triangles) may have
    * normals, but the normals for vertices that are only referenced by
    * point or line primitives are undefined and set to qNaN.  See
    * the #mNormals member for a detailed discussion of qNaNs.
    * @note If the mesh contains tangents, it automatically also
    * contains bitangents.
    */
    aiVector3D *mTangents;

    /** Vertex bitangents.
    * The bitangent of a vertex points in the direction of the positive
    * Y texture axis. The array contains normalized vectors, nullptr if not
    * present. The array is mNumVertices in size.
    * @note If the mesh contains tangents, it automatically also contains
    * bitangents.
    */
    aiVector3D *mBitangents;

    /** Vertex color sets.
    * A mesh may contain 0 to #AI_MAX_NUMBER_OF_COLOR_SETS vertex
    * colors per vertex. nullptr if not present. Each array is
    * mNumVertices in size if present.
    */
    aiColor4D *[AI_MAX_NUMBER_OF_COLOR_SETS] mColors;

    /** Vertex texture coordinates, also known as UV channels.
    * A mesh may contain 0 to AI_MAX_NUMBER_OF_TEXTURECOORDS per
    * vertex. nullptr if not present. The array is mNumVertices in size.
    */
    aiVector3D *[AI_MAX_NUMBER_OF_TEXTURECOORDS] mTextureCoords;

    /** Specifies the number of components for a given UV channel.
    * Up to three channels are supported (UVW, for accessing volume
    * or cube maps). If the value is 2 for a given channel n, the
    * component p.z of mTextureCoords[n][p] is set to 0.0f.
    * If the value is 1 for a given channel, p.y is set to 0.0f, too.
    * @note 4D coordinates are not supported
    */
    uint [AI_MAX_NUMBER_OF_TEXTURECOORDS]mNumUVComponents;

    /** The faces the mesh is constructed from.
    * Each face refers to a number of vertices by their indices.
    * This array is always present in a mesh, its size is given
    * in mNumFaces. If the #AI_SCENE_FLAGS_NON_VERBOSE_FORMAT
    * is NOT set each face references an unique set of vertices.
    */
    aiFace *mFaces;

    /** The number of bones this mesh contains.
    * Can be 0, in which case the mBones array is nullptr.
    */
    uint mNumBones;

    /** The bones of this mesh.
    * A bone consists of a name by which it can be found in the
    * frame hierarchy and a set of vertex weights.
    */
    aiBone **mBones;

    /** The material used by this mesh.
     * A mesh uses only a single material. If an imported model uses
     * multiple materials, the import splits up the mesh. Use this value
     * as index into the scene's material list.
     */
    uint mMaterialIndex;

    /** Name of the mesh. Meshes can be named, but this is not a
     *  requirement and leaving this field empty is totally fine.
     *  There are mainly three uses for mesh names:
     *   - some formats name nodes and meshes independently.
     *   - importers tend to split meshes up to meet the
     *      one-material-per-mesh requirement. Assigning
     *      the same (dummy) name to each of the result meshes
     *      aids the caller at recovering the original mesh
     *      partitioning.
     *   - Vertex animations refer to meshes by their names.
     **/
    aiString mName;

    /** The number of attachment meshes. Note! Currently only works with Collada loader. */
    uint mNumAnimMeshes;

    /** Attachment meshes for this mesh, for vertex-based animation.
     *  Attachment meshes carry replacement data for some of the
     *  mesh'es vertex components (usually positions, normals).
     *  Note! Currently only works with Collada loader.*/
    aiAnimMesh **mAnimMeshes;

    /**
     *  Method of morphing when anim-meshes are specified.
     */
    uint mMethod;

    /**
     *  The bounding box.
     */
    aiAABB mAABB;

    /** Vertex UV stream names. Pointer to array of size AI_MAX_NUMBER_OF_TEXTURECOORDS
     */
    aiString **mTextureCoordsNames;
};

struct aiAABB {
    aiVector3D mMin;
    aiVector3D mMax;
}

enum AI_DEFAULT_MATERIAL_NAME = "DefaultMaterial";

alias aiTextureOp = uint;
enum : uint {
    aiTextureOp_Multiply = 0x0,
    aiTextureOp_Add = 0x1,
    aiTextureOp_Subtract = 0x2,
    aiTextureOp_Divide = 0x3,
    aiTextureOp_SmoothAdd = 0x4,
    aiTextureOp_SignedAdd = 0x5,
}

alias aiTextureMapMode = uint;
enum : uint {
    aiTextureMapMode_Wrap = 0x0,
    aiTextureMapMode_Clamp = 0x1,
    aiTextureMapMode_Decal = 0x3,
    aiTextureMapMode_Mirror = 0x2,
}

alias aiTextureMapping = uint;
enum : uint {
    aiTextureMapping_UV = 0x0,
    aiTextureMapping_SPHERE = 0x1,
    aiTextureMapping_CYLINDER = 0x2,
    aiTextureMapping_BOX = 0x3,
    aiTextureMapping_PLANE = 0x4,
    aiTextureMapping_OTHER = 0x5,
}

alias aiTextureType = uint;
enum : uint {
    aiTextureType_NONE = 0x0,
    aiTextureType_DIFFUSE = 0x1,
    aiTextureType_SPECULAR = 0x2,
    aiTextureType_AMBIENT = 0x3,
    aiTextureType_EMISSIVE = 0x4,
    aiTextureType_HEIGHT = 0x5,
    aiTextureType_NORMALS = 0x6,
    aiTextureType_SHININESS = 0x7,
    aiTextureType_OPACITY = 0x8,
    aiTextureType_DISPLACEMENT = 0x9,
    aiTextureType_LIGHTMAP = 0xA,
    aiTextureType_REFLECTION = 0xB,
    aiTextureType_UNKNOWN = 0xC,
}

alias aiShadingMode = uint;
enum : uint {
    aiShadingMode_Flat = 0x1,
    aiShadingMode_Gouraud = 0x2,
    aiShadingMode_Phong = 0x3,
    aiShadingMode_Blinn = 0x4,
    aiShadingMode_Toon = 0x5,
    aiShadingMode_OrenNayer = 0x6,
    aiShadingMode_Minnaert =0x7,
    aiShadingMode_CookTorrance = 0x8,
    aiShadingMode_NoShading = 0x9,
    aiShadingMode_Fresnel = 0xA,
}

alias aiTextureFlags = uint;
enum : uint {
    aiTextureFlags_Invert = 0x1,
    aiTextureFlags_UseAlpha = 0x2,
    aiTextureFlags_IgnoreAlpha = 0x4,
}

alias aiBlendMode = uint;
enum : uint {
    aiBlendMode_Default = 0x0,
    aiBlendMode_Additive = 0x1,
}

align(1) struct aiUVTransform {
    aiVector2D mTranslation;
    aiVector2D mScaling;
    float mRotation;
}

alias aiPropertyTypeInfo = uint;
enum : uint {
    aiPTI_Float = 0x1,
    aiPTI_String = 0x3,
    aiPTI_Integer = 0x4,
    aiPTI_Buffer = 0x5,
}

struct aiMaterialProperty {
    aiString mKey;
    uint mSemantic;
    uint mIndex;
    uint mDataLength;
    aiPropertyTypeInfo mType;
    byte* mData;
}

struct aiMaterial {
    aiMaterialProperty** mProperties;
    uint mNumProperties;
    uint mNumAllocated;
}

enum {
    AI_MATKEY_NAME = "?mat.name",
    AI_MATKEY_TWOSIDED = "$mat.twosided",
    AI_MATKEY_SHADING_MODEL = "$mat.shadingm",
    AI_MATKEY_ENABLE_WIREFRAM = "$mat.wireframe",
    AI_MATKEY_BLEND_FUNC = "$mat.blend",
    AI_MATKEY_OPACITY = "$mat.opacity",
    AI_MATKEY_BUMPSCALING = "$mat.bumpscaling",
    AI_MATKEY_SHININESS = "$mat.shininess",
    AI_MATKEY_REFLECTIVITY = "$mat.reflectivity",
    AI_MATKEY_SHININESS_STRENGTH = "$mat.shinpercent",
    AI_MATKEY_REFRACTI = "$mat.refracti",
    AI_MATKEY_COLOR_DIFFUSE = "$clr.diffuse",
    AI_MATKEY_COLOR_AMBIENT = "$clr.ambient",
    AI_MATKEY_COLOR_SPECULAR = "$clr.specular",
    AI_MATKEY_COLOR_EMISSIVE = "$clr.emissive",
    AI_MATKEY_COLOR_TRANSPARENT = "$clr.transparent",
    AI_MATKEY_COLOR_REFLECTIVE = "$clr.reflective",
    AI_MATKEY_GLOBAL_BACKGROUND_IMAGE = "?bg.global",
    AI_MATKEY_TEXTURE = "$tex.file",
    AI_MATKEY_UVWSRC = "$tex.uvwsrc",
    AI_MATKEY_TEXOP = "$tex.op",
    AI_MATKEY_MAPPING = "$tex.mapping",
    AI_MATKEY_TEXBLEND = "$tex.blend",
    AI_MATKEY_MAPPINGMODE_U = "$tex.mapmodeu",
    AI_MATKEY_MAPPINGMODE_V = "$tex.mapmodev",
    AI_MATKEY_TEXMAP_AXIS = "$tex.mapaxis",
    AI_MATKEY_UVTRANSFORM = "$tex.uvtrafo",
    AI_MATKEY_TEXFLAGS = "$tex.flags",
}

struct aiVectorKey {
    double mTime;
    aiVector3D mValue;
}

struct aiQuatKey {
    double mTime;
    aiQuaternion mValue;
}

struct aiMeshKey {
    double mTime;
    uint mValue;
}

alias aiAnimBehaviour = uint;
enum : uint {
    aiAnimBehaviour_DEFAULT = 0x0,
    aiAnimBehaviour_CONSTANT = 0x1,
    aiAnimBehaviour_LINEAR = 0x2,
    aiAnimBehaviour_REPEAT = 0x3,
}

struct aiNodeAnim {
    aiString mNodeName;
    uint mNumPositionKeys;
    aiVectorKey* mPositionKeys;
    uint mNumRotationKeys;
    aiQuatKey* mRotationKeys;
    uint mNumScalingKeys;
    aiVectorKey* mScalingKeys;
    aiAnimBehaviour mPreState;
    aiAnimBehaviour mPostState;
}

struct aiMeshAnim {
    aiString mName;
    uint mNumKeys;
    aiMeshKey* mKeys;
}

struct aiAnimation {
    aiString mName;
    double mDuration;
    double mTicksPerSecond;
    uint mNumChannels;
    aiNodeAnim** mChannels;
    uint mNumMeshChannels;
    aiMeshAnim** mMeshChannels;
}

struct aiCamera {
    aiString mName;
    aiVector3D mPosition;
    aiVector3D mUp;
    aiVector3D mLookAt;
    float mHorizontalFOV;
    float mClipPlaneNear;
    float mClipPlaneFar;
    float mAspect;
}

align(1) struct aiTexel {
    ubyte b, g, r, a;
}

struct aiTexture {
    uint mWidth;
    uint mHeight;
    char[4] achFormatHint;
    aiTexel* pcData;
}

alias aiLightSourceType = uint;
enum : uint {
    aiLightSourceType_UNDEFINED = 0x0,
    aiLightSourceType_DIRECTIONAL = 0x1,
    aiLightSourceType_POINT = 0x2,
    aiLightSourceType_SPOT = 0x3,
    aiLightSourceType_AMBIENT = 0x4,
    aiLightSource_AREA = 0x5,
}

struct aiLight {
    aiString mName;
    aiLightSourceType mType;
    aiVector3D mPosition;
    aiVector3D mDirection;
    aiVector3D mUp;
    float mAttenuationConstant;
    float mAttenuationLinear;
    float mAttenuationQuadratic;
    aiColor3D mColorDiffuse;
    aiColor3D mColorSpecular;
    aiColor3D mColorAmbient;
    float mAngleInnerCone;
    float mAngleOuterCone;
    aiVector2D mSize;
}


align(1) struct aiColor4D {
    float r, g, b, a;
}

align(1) struct aiPlane {
    float a, b, c, d;
}

align(1) struct aiRay {
    aiVector3D pos, dir;
}

align(1) struct aiColor3D {
    float r, g, b;
}

struct aiAnimMesh {
    aiVector3D* mVertices;
    aiVector3D* mNormals;
    aiVector3D* mTangents;
    aiVector3D* mBitangents;
    aiColor4D*[AI_MAX_NUMBER_OF_COLOR_SETS] mColors;
    aiVector3D*[AI_MAX_NUMBER_OF_TEXTURECOORDS] mTextureCoords;
    uint mNumVertices;
}

alias aiPostProcessSteps = uint;
enum : uint {
    aiProcess_CalcTangentSpace = 0x1,
    aiProcess_JoinIdenticalVertices = 0x2,
    aiProcess_MakeLeftHanded = 0x4,
    aiProcess_Triangulate = 0x8,
    aiProcess_RemoveComponent = 0x10,
    aiProcess_GenNormals = 0x20,
    aiProcess_GenSmoothNormals = 0x40,
    aiProcess_SplitLargeMeshes = 0x80,
    aiProcess_PreTransformVertices = 0x100,
    aiProcess_LimitBoneWeights = 0x200,
    aiProcess_ValidateDataStructure = 0x400,
    aiProcess_ImproveCacheLocality = 0x800,
    aiProcess_RemoveRedundantMaterials = 0x1000,
    aiProcess_FixInFacingNormals = 0x2000,
    aiProcess_SortByPType = 0x8000,
    aiProcess_FindDegenerates = 0x10000,
    aiProcess_FindInvalidData = 0x20000,
    aiProcess_GenUVCoords = 0x40000,
    aiProcess_TransformUVCoords = 0x80000,
    aiProcess_FindInstances = 0x100000,
    aiProcess_OptimizeMeshes = 0x200000,
    aiProcess_OptimizeGraph = 0x400000,
    aiProcess_FlipUVs = 0x800000,
    aiProcess_FlipWindingOrder = 0x1000000,
    aiProcess_SplitByBoneCount = 0x2000000,
    aiProcess_Debone = 0x4000000,

    aiProcess_ConvertToLeftHanded = aiProcess_MakeLeftHanded | aiProcess_FlipUVs | aiProcess_FlipWindingOrder | 0,
    aiProcessPreset_TargetRealtime_Fast = aiProcess_CalcTangentSpace | aiProcess_GenNormals |
        aiProcess_JoinIdenticalVertices | aiProcess_Triangulate | aiProcess_GenUVCoords |
        aiProcess_SortByPType | 0,
    aiProcessPreset_TargetRealtime_Quality = aiProcess_CalcTangentSpace | aiProcess_GenSmoothNormals | aiProcess_JoinIdenticalVertices |
        aiProcess_ImproveCacheLocality | aiProcess_LimitBoneWeights | aiProcess_RemoveRedundantMaterials |
        aiProcess_SplitLargeMeshes | aiProcess_Triangulate | aiProcess_GenUVCoords | aiProcess_SortByPType |
        aiProcess_FindDegenerates | aiProcess_FindInvalidData | 0,
    aiProcessPreset_TargetRealtime_MaxQuality =
        aiProcessPreset_TargetRealtime_Quality |
        aiProcess_FindInstances | aiProcess_ValidateDataStructure |
        aiProcess_OptimizeMeshes | aiProcess_Debone | 0,
}
}
