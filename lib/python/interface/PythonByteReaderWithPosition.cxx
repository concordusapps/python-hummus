// #include "PythonByteReaderWithPosition.h"
// #include "hummus/interface_api.h"

// PythonByteReaderWithPosition::PythonByteReaderWithPosition(PyObject* obj) : _obj(obj) {
//     import_hummus__interface();
//     Py_XINCREF(_obj);
// }

// PythonByteReaderWithPosition::~PythonByteReaderWithPosition() {
//     Py_XDECREF(_obj);
// }

// IOBasicTypes::LongBufferSizeType PythonByteReaderWithPosition::Read(
//         const IOBasicTypes::Byte* stream,
//         IOBasicTypes::LongBufferSizeType size) {
//     return _hummus_br_read(_obj, stream, size);
// }

// bool PythonByteReaderWithPosition::NotEnded() {
//     return _hummus_br_eof(obj);
// }

// void PythonByteReaderWithPosition::SetPosition(LongFilePositionType offset) {
//     _hummus_br_seek_from_begin(obj, offset);
// }

// void PythonByteReaderWithPosition::SetPositionFromEnd(
//         LongFilePositionType offset) {
//     _hummus_br_seek_from_end(obj, offset);
// }

// LongFilePositionType PythonByteReaderWithPosition::GetCurrentPosition() {
//     return _hummus_br_tell(obj);
// }

// void PythonByteReaderWithPosition::Skip(LongBufferSizeType offset) {
//     _hummus_br_seek(obj, offset);
// }
