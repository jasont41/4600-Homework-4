
_touch:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc,char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	be 01 00 00 00       	mov    $0x1,%esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  1c:	8b 39                	mov    (%ecx),%edi
  1e:	83 c3 04             	add    $0x4,%ebx
    if(argc<2)
  21:	83 ff 01             	cmp    $0x1,%edi
  24:	7e 4f                	jle    75 <main+0x75>
  26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2d:	8d 76 00             	lea    0x0(%esi),%esi
        exit();
    }
    int i,err;
    for(i=1;i<argc;i++)
    {
        if((err=open(argv[i],O_CREATE|O_RDWR)) < 0)
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 02 02 00 00       	push   $0x202
  38:	ff 33                	pushl  (%ebx)
  3a:	e8 e4 02 00 00       	call   323 <open>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	85 c0                	test   %eax,%eax
  44:	78 1b                	js     61 <main+0x61>
        {
            printf(1,"touch: error where creating %s\n",argv[i]);
            exit();
        }
        close(err);
  46:	83 ec 0c             	sub    $0xc,%esp
    for(i=1;i<argc;i++)
  49:	83 c6 01             	add    $0x1,%esi
  4c:	83 c3 04             	add    $0x4,%ebx
        close(err);
  4f:	50                   	push   %eax
  50:	e8 b6 02 00 00       	call   30b <close>
    for(i=1;i<argc;i++)
  55:	83 c4 10             	add    $0x10,%esp
  58:	39 f7                	cmp    %esi,%edi
  5a:	75 d4                	jne    30 <main+0x30>
    }
    exit();
  5c:	e8 82 02 00 00       	call   2e3 <exit>
            printf(1,"touch: error where creating %s\n",argv[i]);
  61:	50                   	push   %eax
  62:	ff 33                	pushl  (%ebx)
  64:	68 d4 07 00 00       	push   $0x7d4
  69:	6a 01                	push   $0x1
  6b:	e8 e0 03 00 00       	call   450 <printf>
            exit();
  70:	e8 6e 02 00 00       	call   2e3 <exit>
        printf(1,"Usage: touch [files]...\n");
  75:	52                   	push   %edx
  76:	52                   	push   %edx
  77:	68 b8 07 00 00       	push   $0x7b8
  7c:	6a 01                	push   $0x1
  7e:	e8 cd 03 00 00       	call   450 <printf>
        exit();
  83:	e8 5b 02 00 00       	call   2e3 <exit>
  88:	66 90                	xchg   %ax,%ax
  8a:	66 90                	xchg   %ax,%ax
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  90:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  91:	31 c0                	xor    %eax,%eax
{
  93:	89 e5                	mov    %esp,%ebp
  95:	53                   	push   %ebx
  96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  a7:	83 c0 01             	add    $0x1,%eax
  aa:	84 d2                	test   %dl,%dl
  ac:	75 f2                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  ae:	89 c8                	mov    %ecx,%eax
  b0:	5b                   	pop    %ebx
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    
  b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ca:	0f b6 01             	movzbl (%ecx),%eax
  cd:	0f b6 1a             	movzbl (%edx),%ebx
  d0:	84 c0                	test   %al,%al
  d2:	75 1d                	jne    f1 <strcmp+0x31>
  d4:	eb 2a                	jmp    100 <strcmp+0x40>
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  e4:	83 c1 01             	add    $0x1,%ecx
  e7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  ea:	0f b6 1a             	movzbl (%edx),%ebx
  ed:	84 c0                	test   %al,%al
  ef:	74 0f                	je     100 <strcmp+0x40>
  f1:	38 d8                	cmp    %bl,%al
  f3:	74 eb                	je     e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  f5:	29 d8                	sub    %ebx,%eax
}
  f7:	5b                   	pop    %ebx
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    
  fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 100:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 102:	29 d8                	sub    %ebx,%eax
}
 104:	5b                   	pop    %ebx
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax

00000110 <strlen>:

uint
strlen(char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 3a 00             	cmpb   $0x0,(%edx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 c0                	xor    %eax,%eax
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c0 01             	add    $0x1,%eax
 123:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 127:	89 c1                	mov    %eax,%ecx
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	89 c8                	mov    %ecx,%eax
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
 12f:	90                   	nop
  for(n = 0; s[n]; n++)
 130:	31 c9                	xor    %ecx,%ecx
}
 132:	5d                   	pop    %ebp
 133:	89 c8                	mov    %ecx,%eax
 135:	c3                   	ret    
 136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13d:	8d 76 00             	lea    0x0(%esi),%esi

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	89 d0                	mov    %edx,%eax
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15e:	66 90                	xchg   %ax,%ax

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	75 12                	jne    183 <strchr+0x23>
 171:	eb 1d                	jmp    190 <strchr+0x30>
 173:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 177:	90                   	nop
 178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	84 d2                	test   %dl,%dl
 181:	74 0d                	je     190 <strchr+0x30>
    if(*s == c)
 183:	38 d1                	cmp    %dl,%cl
 185:	75 f1                	jne    178 <strchr+0x18>
      return (char*)s;
  return 0;
}
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 190:	31 c0                	xor    %eax,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
 194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 19f:	90                   	nop

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a5:	31 f6                	xor    %esi,%esi
{
 1a7:	53                   	push   %ebx
 1a8:	89 f3                	mov    %esi,%ebx
 1aa:	83 ec 1c             	sub    $0x1c,%esp
 1ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1b0:	eb 2f                	jmp    1e1 <gets+0x41>
 1b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1b8:	83 ec 04             	sub    $0x4,%esp
 1bb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1be:	6a 01                	push   $0x1
 1c0:	50                   	push   %eax
 1c1:	6a 00                	push   $0x0
 1c3:	e8 33 01 00 00       	call   2fb <read>
    if(cc < 1)
 1c8:	83 c4 10             	add    $0x10,%esp
 1cb:	85 c0                	test   %eax,%eax
 1cd:	7e 1c                	jle    1eb <gets+0x4b>
      break;
    buf[i++] = c;
 1cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d3:	83 c7 01             	add    $0x1,%edi
 1d6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1d9:	3c 0a                	cmp    $0xa,%al
 1db:	74 23                	je     200 <gets+0x60>
 1dd:	3c 0d                	cmp    $0xd,%al
 1df:	74 1f                	je     200 <gets+0x60>
  for(i=0; i+1 < max; ){
 1e1:	83 c3 01             	add    $0x1,%ebx
 1e4:	89 fe                	mov    %edi,%esi
 1e6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e9:	7c cd                	jl     1b8 <gets+0x18>
 1eb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1f0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f6:	5b                   	pop    %ebx
 1f7:	5e                   	pop    %esi
 1f8:	5f                   	pop    %edi
 1f9:	5d                   	pop    %ebp
 1fa:	c3                   	ret    
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop
 200:	8b 75 08             	mov    0x8(%ebp),%esi
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	01 de                	add    %ebx,%esi
 208:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 20a:	c6 03 00             	movb   $0x0,(%ebx)
}
 20d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 210:	5b                   	pop    %ebx
 211:	5e                   	pop    %esi
 212:	5f                   	pop    %edi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    
 215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <stat>:

int
stat(char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	6a 00                	push   $0x0
 22a:	ff 75 08             	pushl  0x8(%ebp)
 22d:	e8 f1 00 00 00       	call   323 <open>
  if(fd < 0)
 232:	83 c4 10             	add    $0x10,%esp
 235:	85 c0                	test   %eax,%eax
 237:	78 27                	js     260 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	ff 75 0c             	pushl  0xc(%ebp)
 23f:	89 c3                	mov    %eax,%ebx
 241:	50                   	push   %eax
 242:	e8 f4 00 00 00       	call   33b <fstat>
  close(fd);
 247:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 24a:	89 c6                	mov    %eax,%esi
  close(fd);
 24c:	e8 ba 00 00 00       	call   30b <close>
  return r;
 251:	83 c4 10             	add    $0x10,%esp
}
 254:	8d 65 f8             	lea    -0x8(%ebp),%esp
 257:	89 f0                	mov    %esi,%eax
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 260:	be ff ff ff ff       	mov    $0xffffffff,%esi
 265:	eb ed                	jmp    254 <stat+0x34>
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax

00000270 <atoi>:

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	0f be 02             	movsbl (%edx),%eax
 27a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 27d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 280:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 285:	77 1e                	ja     2a5 <atoi+0x35>
 287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 290:	83 c2 01             	add    $0x1,%edx
 293:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 296:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 29a:	0f be 02             	movsbl (%edx),%eax
 29d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2a0:	80 fb 09             	cmp    $0x9,%bl
 2a3:	76 eb                	jbe    290 <atoi+0x20>
  return n;
}
 2a5:	89 c8                	mov    %ecx,%eax
 2a7:	5b                   	pop    %ebx
 2a8:	5d                   	pop    %ebp
 2a9:	c3                   	ret    
 2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
 2b7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ba:	56                   	push   %esi
 2bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7e 13                	jle    2d5 <memmove+0x25>
 2c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2c4:	89 d7                	mov    %edx,%edi
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2d1:	39 f8                	cmp    %edi,%eax
 2d3:	75 fb                	jne    2d0 <memmove+0x20>
  return vdst;
}
 2d5:	5e                   	pop    %esi
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    

000002db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2db:	b8 01 00 00 00       	mov    $0x1,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <exit>:
SYSCALL(exit)
 2e3:	b8 02 00 00 00       	mov    $0x2,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <wait>:
SYSCALL(wait)
 2eb:	b8 03 00 00 00       	mov    $0x3,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <pipe>:
SYSCALL(pipe)
 2f3:	b8 04 00 00 00       	mov    $0x4,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <read>:
SYSCALL(read)
 2fb:	b8 05 00 00 00       	mov    $0x5,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <write>:
SYSCALL(write)
 303:	b8 10 00 00 00       	mov    $0x10,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <close>:
SYSCALL(close)
 30b:	b8 15 00 00 00       	mov    $0x15,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <kill>:
SYSCALL(kill)
 313:	b8 06 00 00 00       	mov    $0x6,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <exec>:
SYSCALL(exec)
 31b:	b8 07 00 00 00       	mov    $0x7,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <open>:
SYSCALL(open)
 323:	b8 0f 00 00 00       	mov    $0xf,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <mknod>:
SYSCALL(mknod)
 32b:	b8 11 00 00 00       	mov    $0x11,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <unlink>:
SYSCALL(unlink)
 333:	b8 12 00 00 00       	mov    $0x12,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <fstat>:
SYSCALL(fstat)
 33b:	b8 08 00 00 00       	mov    $0x8,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <link>:
SYSCALL(link)
 343:	b8 13 00 00 00       	mov    $0x13,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <mkdir>:
SYSCALL(mkdir)
 34b:	b8 14 00 00 00       	mov    $0x14,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <chdir>:
SYSCALL(chdir)
 353:	b8 09 00 00 00       	mov    $0x9,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <dup>:
SYSCALL(dup)
 35b:	b8 0a 00 00 00       	mov    $0xa,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <getpid>:
SYSCALL(getpid)
 363:	b8 0b 00 00 00       	mov    $0xb,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <sbrk>:
SYSCALL(sbrk)
 36b:	b8 0c 00 00 00       	mov    $0xc,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <sleep>:
SYSCALL(sleep)
 373:	b8 0d 00 00 00       	mov    $0xd,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <uptime>:
SYSCALL(uptime)
 37b:	b8 0e 00 00 00       	mov    $0xe,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <cps>:
SYSCALL(cps)
 383:	b8 16 00 00 00       	mov    $0x16,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <nps>:
SYSCALL(nps)
 38b:	b8 17 00 00 00       	mov    $0x17,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    
 393:	66 90                	xchg   %ax,%ax
 395:	66 90                	xchg   %ax,%ax
 397:	66 90                	xchg   %ax,%ax
 399:	66 90                	xchg   %ax,%ax
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	83 ec 3c             	sub    $0x3c,%esp
 3a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3ac:	89 d1                	mov    %edx,%ecx
{
 3ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3b1:	85 d2                	test   %edx,%edx
 3b3:	0f 89 7f 00 00 00    	jns    438 <printint+0x98>
 3b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3bd:	74 79                	je     438 <printint+0x98>
    neg = 1;
 3bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3c8:	31 db                	xor    %ebx,%ebx
 3ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3d0:	89 c8                	mov    %ecx,%eax
 3d2:	31 d2                	xor    %edx,%edx
 3d4:	89 cf                	mov    %ecx,%edi
 3d6:	f7 75 c4             	divl   -0x3c(%ebp)
 3d9:	0f b6 92 fc 07 00 00 	movzbl 0x7fc(%edx),%edx
 3e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3e3:	89 d8                	mov    %ebx,%eax
 3e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3f1:	76 dd                	jbe    3d0 <printint+0x30>
  if(neg)
 3f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3f6:	85 c9                	test   %ecx,%ecx
 3f8:	74 0c                	je     406 <printint+0x66>
    buf[i++] = '-';
 3fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 3ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 401:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 406:	8b 7d b8             	mov    -0x48(%ebp),%edi
 409:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 40d:	eb 07                	jmp    416 <printint+0x76>
 40f:	90                   	nop
 410:	0f b6 13             	movzbl (%ebx),%edx
 413:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 416:	83 ec 04             	sub    $0x4,%esp
 419:	88 55 d7             	mov    %dl,-0x29(%ebp)
 41c:	6a 01                	push   $0x1
 41e:	56                   	push   %esi
 41f:	57                   	push   %edi
 420:	e8 de fe ff ff       	call   303 <write>
  while(--i >= 0)
 425:	83 c4 10             	add    $0x10,%esp
 428:	39 de                	cmp    %ebx,%esi
 42a:	75 e4                	jne    410 <printint+0x70>
    putc(fd, buf[i]);
}
 42c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42f:	5b                   	pop    %ebx
 430:	5e                   	pop    %esi
 431:	5f                   	pop    %edi
 432:	5d                   	pop    %ebp
 433:	c3                   	ret    
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 438:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 43f:	eb 87                	jmp    3c8 <printint+0x28>
 441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 459:	8b 75 0c             	mov    0xc(%ebp),%esi
 45c:	0f b6 1e             	movzbl (%esi),%ebx
 45f:	84 db                	test   %bl,%bl
 461:	0f 84 b8 00 00 00    	je     51f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 467:	8d 45 10             	lea    0x10(%ebp),%eax
 46a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 46d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 470:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 472:	89 45 d0             	mov    %eax,-0x30(%ebp)
 475:	eb 37                	jmp    4ae <printf+0x5e>
 477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47e:	66 90                	xchg   %ax,%ax
 480:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 483:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 488:	83 f8 25             	cmp    $0x25,%eax
 48b:	74 17                	je     4a4 <printf+0x54>
  write(fd, &c, 1);
 48d:	83 ec 04             	sub    $0x4,%esp
 490:	88 5d e7             	mov    %bl,-0x19(%ebp)
 493:	6a 01                	push   $0x1
 495:	57                   	push   %edi
 496:	ff 75 08             	pushl  0x8(%ebp)
 499:	e8 65 fe ff ff       	call   303 <write>
 49e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4a1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4a4:	0f b6 1e             	movzbl (%esi),%ebx
 4a7:	83 c6 01             	add    $0x1,%esi
 4aa:	84 db                	test   %bl,%bl
 4ac:	74 71                	je     51f <printf+0xcf>
    c = fmt[i] & 0xff;
 4ae:	0f be cb             	movsbl %bl,%ecx
 4b1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4b4:	85 d2                	test   %edx,%edx
 4b6:	74 c8                	je     480 <printf+0x30>
      }
    } else if(state == '%'){
 4b8:	83 fa 25             	cmp    $0x25,%edx
 4bb:	75 e7                	jne    4a4 <printf+0x54>
      if(c == 'd'){
 4bd:	83 f8 64             	cmp    $0x64,%eax
 4c0:	0f 84 9a 00 00 00    	je     560 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4cc:	83 f9 70             	cmp    $0x70,%ecx
 4cf:	74 5f                	je     530 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4d1:	83 f8 73             	cmp    $0x73,%eax
 4d4:	0f 84 d6 00 00 00    	je     5b0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4da:	83 f8 63             	cmp    $0x63,%eax
 4dd:	0f 84 8d 00 00 00    	je     570 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e3:	83 f8 25             	cmp    $0x25,%eax
 4e6:	0f 84 b4 00 00 00    	je     5a0 <printf+0x150>
  write(fd, &c, 1);
 4ec:	83 ec 04             	sub    $0x4,%esp
 4ef:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4f3:	6a 01                	push   $0x1
 4f5:	57                   	push   %edi
 4f6:	ff 75 08             	pushl  0x8(%ebp)
 4f9:	e8 05 fe ff ff       	call   303 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4fe:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 501:	83 c4 0c             	add    $0xc,%esp
 504:	6a 01                	push   $0x1
 506:	83 c6 01             	add    $0x1,%esi
 509:	57                   	push   %edi
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 f1 fd ff ff       	call   303 <write>
  for(i = 0; fmt[i]; i++){
 512:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 516:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 519:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 51b:	84 db                	test   %bl,%bl
 51d:	75 8f                	jne    4ae <printf+0x5e>
    }
  }
}
 51f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 522:	5b                   	pop    %ebx
 523:	5e                   	pop    %esi
 524:	5f                   	pop    %edi
 525:	5d                   	pop    %ebp
 526:	c3                   	ret    
 527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 530:	83 ec 0c             	sub    $0xc,%esp
 533:	b9 10 00 00 00       	mov    $0x10,%ecx
 538:	6a 00                	push   $0x0
 53a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	8b 13                	mov    (%ebx),%edx
 542:	e8 59 fe ff ff       	call   3a0 <printint>
        ap++;
 547:	89 d8                	mov    %ebx,%eax
 549:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54c:	31 d2                	xor    %edx,%edx
        ap++;
 54e:	83 c0 04             	add    $0x4,%eax
 551:	89 45 d0             	mov    %eax,-0x30(%ebp)
 554:	e9 4b ff ff ff       	jmp    4a4 <printf+0x54>
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 560:	83 ec 0c             	sub    $0xc,%esp
 563:	b9 0a 00 00 00       	mov    $0xa,%ecx
 568:	6a 01                	push   $0x1
 56a:	eb ce                	jmp    53a <printf+0xea>
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 570:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 573:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 576:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 578:	6a 01                	push   $0x1
        ap++;
 57a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 57d:	57                   	push   %edi
 57e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 581:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 584:	e8 7a fd ff ff       	call   303 <write>
        ap++;
 589:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 58c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58f:	31 d2                	xor    %edx,%edx
 591:	e9 0e ff ff ff       	jmp    4a4 <printf+0x54>
 596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 5a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5a3:	83 ec 04             	sub    $0x4,%esp
 5a6:	e9 59 ff ff ff       	jmp    504 <printf+0xb4>
 5ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop
        s = (char*)*ap;
 5b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5b5:	83 c0 04             	add    $0x4,%eax
 5b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5bb:	85 db                	test   %ebx,%ebx
 5bd:	74 17                	je     5d6 <printf+0x186>
        while(*s != 0){
 5bf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5c2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5c4:	84 c0                	test   %al,%al
 5c6:	0f 84 d8 fe ff ff    	je     4a4 <printf+0x54>
 5cc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5cf:	89 de                	mov    %ebx,%esi
 5d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5d4:	eb 1a                	jmp    5f0 <printf+0x1a0>
          s = "(null)";
 5d6:	bb f4 07 00 00       	mov    $0x7f4,%ebx
        while(*s != 0){
 5db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5de:	b8 28 00 00 00       	mov    $0x28,%eax
 5e3:	89 de                	mov    %ebx,%esi
 5e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5f3:	83 c6 01             	add    $0x1,%esi
 5f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5f9:	6a 01                	push   $0x1
 5fb:	57                   	push   %edi
 5fc:	53                   	push   %ebx
 5fd:	e8 01 fd ff ff       	call   303 <write>
        while(*s != 0){
 602:	0f b6 06             	movzbl (%esi),%eax
 605:	83 c4 10             	add    $0x10,%esp
 608:	84 c0                	test   %al,%al
 60a:	75 e4                	jne    5f0 <printf+0x1a0>
 60c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 60f:	31 d2                	xor    %edx,%edx
 611:	e9 8e fe ff ff       	jmp    4a4 <printf+0x54>
 616:	66 90                	xchg   %ax,%ax
 618:	66 90                	xchg   %ax,%ax
 61a:	66 90                	xchg   %ax,%ax
 61c:	66 90                	xchg   %ax,%ax
 61e:	66 90                	xchg   %ax,%ax

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 b4 0a 00 00       	mov    0xab4,%eax
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 62e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 630:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	39 c8                	cmp    %ecx,%eax
 635:	73 19                	jae    650 <free+0x30>
 637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63e:	66 90                	xchg   %ax,%ax
 640:	39 d1                	cmp    %edx,%ecx
 642:	72 14                	jb     658 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	39 d0                	cmp    %edx,%eax
 646:	73 10                	jae    658 <free+0x38>
{
 648:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64a:	8b 10                	mov    (%eax),%edx
 64c:	39 c8                	cmp    %ecx,%eax
 64e:	72 f0                	jb     640 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 d0                	cmp    %edx,%eax
 652:	72 f4                	jb     648 <free+0x28>
 654:	39 d1                	cmp    %edx,%ecx
 656:	73 f0                	jae    648 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 658:	8b 73 fc             	mov    -0x4(%ebx),%esi
 65b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65e:	39 fa                	cmp    %edi,%edx
 660:	74 1e                	je     680 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 662:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 66b:	39 f1                	cmp    %esi,%ecx
 66d:	74 28                	je     697 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 66f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 671:	5b                   	pop    %ebx
  freep = p;
 672:	a3 b4 0a 00 00       	mov    %eax,0xab4
}
 677:	5e                   	pop    %esi
 678:	5f                   	pop    %edi
 679:	5d                   	pop    %ebp
 67a:	c3                   	ret    
 67b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 680:	03 72 04             	add    0x4(%edx),%esi
 683:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 686:	8b 10                	mov    (%eax),%edx
 688:	8b 12                	mov    (%edx),%edx
 68a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 693:	39 f1                	cmp    %esi,%ecx
 695:	75 d8                	jne    66f <free+0x4f>
    p->s.size += bp->s.size;
 697:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 69a:	a3 b4 0a 00 00       	mov    %eax,0xab4
    p->s.size += bp->s.size;
 69f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6a5:	89 10                	mov    %edx,(%eax)
}
 6a7:	5b                   	pop    %ebx
 6a8:	5e                   	pop    %esi
 6a9:	5f                   	pop    %edi
 6aa:	5d                   	pop    %ebp
 6ab:	c3                   	ret    
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6bc:	8b 3d b4 0a 00 00    	mov    0xab4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	8d 70 07             	lea    0x7(%eax),%esi
 6c5:	c1 ee 03             	shr    $0x3,%esi
 6c8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6cb:	85 ff                	test   %edi,%edi
 6cd:	0f 84 ad 00 00 00    	je     780 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d3:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6d5:	8b 48 04             	mov    0x4(%eax),%ecx
 6d8:	39 f1                	cmp    %esi,%ecx
 6da:	73 71                	jae    74d <malloc+0x9d>
 6dc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6e7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ea:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6f4:	eb 1b                	jmp    711 <malloc+0x61>
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 700:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 702:	8b 4a 04             	mov    0x4(%edx),%ecx
 705:	39 f1                	cmp    %esi,%ecx
 707:	73 4f                	jae    758 <malloc+0xa8>
 709:	8b 3d b4 0a 00 00    	mov    0xab4,%edi
 70f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 711:	39 c7                	cmp    %eax,%edi
 713:	75 eb                	jne    700 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 715:	83 ec 0c             	sub    $0xc,%esp
 718:	ff 75 e4             	pushl  -0x1c(%ebp)
 71b:	e8 4b fc ff ff       	call   36b <sbrk>
  if(p == (char*)-1)
 720:	83 c4 10             	add    $0x10,%esp
 723:	83 f8 ff             	cmp    $0xffffffff,%eax
 726:	74 1b                	je     743 <malloc+0x93>
  hp->s.size = nu;
 728:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 72b:	83 ec 0c             	sub    $0xc,%esp
 72e:	83 c0 08             	add    $0x8,%eax
 731:	50                   	push   %eax
 732:	e8 e9 fe ff ff       	call   620 <free>
  return freep;
 737:	a1 b4 0a 00 00       	mov    0xab4,%eax
      if((p = morecore(nunits)) == 0)
 73c:	83 c4 10             	add    $0x10,%esp
 73f:	85 c0                	test   %eax,%eax
 741:	75 bd                	jne    700 <malloc+0x50>
        return 0;
  }
}
 743:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 746:	31 c0                	xor    %eax,%eax
}
 748:	5b                   	pop    %ebx
 749:	5e                   	pop    %esi
 74a:	5f                   	pop    %edi
 74b:	5d                   	pop    %ebp
 74c:	c3                   	ret    
    if(p->s.size >= nunits){
 74d:	89 c2                	mov    %eax,%edx
 74f:	89 f8                	mov    %edi,%eax
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 758:	39 ce                	cmp    %ecx,%esi
 75a:	74 54                	je     7b0 <malloc+0x100>
        p->s.size -= nunits;
 75c:	29 f1                	sub    %esi,%ecx
 75e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 761:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 764:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 767:	a3 b4 0a 00 00       	mov    %eax,0xab4
}
 76c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 76f:	8d 42 08             	lea    0x8(%edx),%eax
}
 772:	5b                   	pop    %ebx
 773:	5e                   	pop    %esi
 774:	5f                   	pop    %edi
 775:	5d                   	pop    %ebp
 776:	c3                   	ret    
 777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 780:	c7 05 b4 0a 00 00 b8 	movl   $0xab8,0xab4
 787:	0a 00 00 
    base.s.size = 0;
 78a:	bf b8 0a 00 00       	mov    $0xab8,%edi
    base.s.ptr = freep = prevp = &base;
 78f:	c7 05 b8 0a 00 00 b8 	movl   $0xab8,0xab8
 796:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 799:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 79b:	c7 05 bc 0a 00 00 00 	movl   $0x0,0xabc
 7a2:	00 00 00 
    if(p->s.size >= nunits){
 7a5:	e9 32 ff ff ff       	jmp    6dc <malloc+0x2c>
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7b0:	8b 0a                	mov    (%edx),%ecx
 7b2:	89 08                	mov    %ecx,(%eax)
 7b4:	eb b1                	jmp    767 <malloc+0xb7>
