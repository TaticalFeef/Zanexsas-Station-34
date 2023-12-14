//duvido a justica me pegar 3Bo)
#define DIRECT_OUTPUTT(A, B) A << B
#define SEND_IMAGEE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUNDD(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXTT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILEE(file, text) DIRECT_OUTPUT(file, text)
#define WRITE_LOGG(log, text) rustg_log_write(log, text)