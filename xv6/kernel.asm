
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 2f 10 80       	mov    $0x80102f70,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 6f 10 80       	push   $0x80106fc0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 25 43 00 00       	call   80104380 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6f 10 80       	push   $0x80106fc7
80100097:	50                   	push   %eax
80100098:	e8 d3 41 00 00       	call   80104270 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 97 43 00 00       	call   80104480 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 39 44 00 00       	call   801045a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 41 00 00       	call   801042b0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 20 00 00       	call   801021f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 6f 10 80       	push   $0x80106fce
801001a8:	e8 d3 01 00 00       	call   80100380 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 8d 41 00 00       	call   80104350 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 20 00 00       	jmp    801021f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 6f 10 80       	push   $0x80106fdf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 41 00 00       	call   80104350 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 fc 40 00 00       	call   80104310 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 60 42 00 00       	call   80104480 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 2f 43 00 00       	jmp    801045a0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 6f 10 80       	push   $0x80106fe6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
8010028f:	89 de                	mov    %ebx,%esi
  iunlock(ip);
80100291:	e8 5a 15 00 00       	call   801017f0 <iunlock>
  acquire(&cons.lock);
80100296:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029d:	e8 de 41 00 00       	call   80104480 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002a8:	01 df                	add    %ebx,%edi
  while(n > 0){
801002aa:	85 db                	test   %ebx,%ebx
801002ac:	0f 8e 9b 00 00 00    	jle    8010034d <consoleread+0xcd>
    while(input.r == input.w){
801002b2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002b7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002bd:	74 2b                	je     801002ea <consoleread+0x6a>
801002bf:	eb 5f                	jmp    80100320 <consoleread+0xa0>
801002c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 26 3b 00 00       	call   80103e00 <sleep>
    while(input.r == input.w){
801002da:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002df:	83 c4 10             	add    $0x10,%esp
801002e2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002e8:	75 36                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002ea:	e8 71 35 00 00       	call   80103860 <myproc>
801002ef:	8b 48 24             	mov    0x24(%eax),%ecx
801002f2:	85 c9                	test   %ecx,%ecx
801002f4:	74 d2                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f6:	83 ec 0c             	sub    $0xc,%esp
801002f9:	68 20 a5 10 80       	push   $0x8010a520
801002fe:	e8 9d 42 00 00       	call   801045a0 <release>
        ilock(ip);
80100303:	5a                   	pop    %edx
80100304:	ff 75 08             	pushl  0x8(%ebp)
80100307:	e8 04 14 00 00       	call   80101710 <ilock>
        return -1;
8010030c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010030f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100317:	5b                   	pop    %ebx
80100318:	5e                   	pop    %esi
80100319:	5f                   	pop    %edi
8010031a:	5d                   	pop    %ebp
8010031b:	c3                   	ret    
8010031c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 50 01             	lea    0x1(%eax),%edx
80100323:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100329:	89 c2                	mov    %eax,%edx
8010032b:	83 e2 7f             	and    $0x7f,%edx
8010032e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100335:	80 f9 04             	cmp    $0x4,%cl
80100338:	74 38                	je     80100372 <consoleread+0xf2>
    *dst++ = c;
8010033a:	89 d8                	mov    %ebx,%eax
    --n;
8010033c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033f:	f7 d8                	neg    %eax
80100341:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100344:	83 f9 0a             	cmp    $0xa,%ecx
80100347:	0f 85 5d ff ff ff    	jne    801002aa <consoleread+0x2a>
  release(&cons.lock);
8010034d:	83 ec 0c             	sub    $0xc,%esp
80100350:	68 20 a5 10 80       	push   $0x8010a520
80100355:	e8 46 42 00 00       	call   801045a0 <release>
  ilock(ip);
8010035a:	58                   	pop    %eax
8010035b:	ff 75 08             	pushl  0x8(%ebp)
8010035e:	e8 ad 13 00 00       	call   80101710 <ilock>
  return target - n;
80100363:	89 f0                	mov    %esi,%eax
80100365:	83 c4 10             	add    $0x10,%esp
}
80100368:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010036b:	29 d8                	sub    %ebx,%eax
}
8010036d:	5b                   	pop    %ebx
8010036e:	5e                   	pop    %esi
8010036f:	5f                   	pop    %edi
80100370:	5d                   	pop    %ebp
80100371:	c3                   	ret    
      if(n < target){
80100372:	39 f3                	cmp    %esi,%ebx
80100374:	73 d7                	jae    8010034d <consoleread+0xcd>
        input.r--;
80100376:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010037b:	eb d0                	jmp    8010034d <consoleread+0xcd>
8010037d:	8d 76 00             	lea    0x0(%esi),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 24 00 00       	call   80102800 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 6f 10 80       	push   $0x80106fed
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 cb 75 10 80 	movl   $0x801075cb,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 3f 00 00       	call   801043a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
801003d5:	83 c3 04             	add    $0x4,%ebx
801003d8:	68 01 70 10 80       	push   $0x80107001
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 d1 57 00 00       	call   80105bf0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100434:	89 ca                	mov    %ecx,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c6                	mov    %eax,%esi
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 ca                	mov    %ecx,%edx
80100449:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 90 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	74 70                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100460:	0f b6 db             	movzbl %bl,%ebx
80100463:	8d 70 01             	lea    0x1(%eax),%esi
80100466:	80 cf 07             	or     $0x7,%bh
80100469:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100470:	80 
  if(pos < 0 || pos > 25*80)
80100471:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100477:	0f 8f f9 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100483:	0f 8f a7 00 00 00    	jg     80100530 <consputc.part.0+0x130>
80100489:	89 f0                	mov    %esi,%eax
8010048b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
80100492:	88 45 e7             	mov    %al,-0x19(%ebp)
80100495:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100498:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049d:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a2:	89 da                	mov    %ebx,%edx
801004a4:	ee                   	out    %al,(%dx)
801004a5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004aa:	89 f8                	mov    %edi,%eax
801004ac:	89 ca                	mov    %ecx,%edx
801004ae:	ee                   	out    %al,(%dx)
801004af:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b4:	89 da                	mov    %ebx,%edx
801004b6:	ee                   	out    %al,(%dx)
801004b7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004bb:	89 ca                	mov    %ecx,%edx
801004bd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 06             	mov    %ax,(%esi)
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
801004ce:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 9a                	jne    80100471 <consputc.part.0+0x71>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b4                	jmp    80100498 <consputc.part.0+0x98>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 71 ff ff ff       	jmp    80100471 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 e6 56 00 00       	call   80105bf0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 da 56 00 00       	call   80105bf0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ce 56 00 00       	call   80105bf0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 3a 41 00 00       	call   80104690 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 85 40 00 00       	call   801045f0 <memset>
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 22 ff ff ff       	jmp    80100498 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 70 10 80       	push   $0x80107005
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <printint>:
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 2c             	sub    $0x2c,%esp
80100599:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010059c:	85 c9                	test   %ecx,%ecx
8010059e:	74 04                	je     801005a4 <printint+0x14>
801005a0:	85 c0                	test   %eax,%eax
801005a2:	78 6d                	js     80100611 <printint+0x81>
    x = xx;
801005a4:	89 c1                	mov    %eax,%ecx
801005a6:	31 f6                	xor    %esi,%esi
  i = 0;
801005a8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005ab:	31 db                	xor    %ebx,%ebx
801005ad:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005b0:	89 c8                	mov    %ecx,%eax
801005b2:	31 d2                	xor    %edx,%edx
801005b4:	89 ce                	mov    %ecx,%esi
801005b6:	f7 75 d4             	divl   -0x2c(%ebp)
801005b9:	0f b6 92 30 70 10 80 	movzbl -0x7fef8fd0(%edx),%edx
801005c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005c3:	89 d8                	mov    %ebx,%eax
801005c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005c8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005cb:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005ce:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005d1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005d4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005d7:	73 d7                	jae    801005b0 <printint+0x20>
801005d9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005dc:	85 f6                	test   %esi,%esi
801005de:	74 0c                	je     801005ec <printint+0x5c>
    buf[i++] = '-';
801005e0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005e5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005e7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005ec:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
801005f0:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801005f3:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801005f9:	85 d2                	test   %edx,%edx
801005fb:	74 03                	je     80100600 <printint+0x70>
  asm volatile("cli");
801005fd:	fa                   	cli    
    for(;;)
801005fe:	eb fe                	jmp    801005fe <printint+0x6e>
80100600:	e8 fb fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100605:	39 fb                	cmp    %edi,%ebx
80100607:	74 10                	je     80100619 <printint+0x89>
80100609:	0f be 03             	movsbl (%ebx),%eax
8010060c:	83 eb 01             	sub    $0x1,%ebx
8010060f:	eb e2                	jmp    801005f3 <printint+0x63>
    x = -xx;
80100611:	f7 d8                	neg    %eax
80100613:	89 ce                	mov    %ecx,%esi
80100615:	89 c1                	mov    %eax,%ecx
80100617:	eb 8f                	jmp    801005a8 <printint+0x18>
}
80100619:	83 c4 2c             	add    $0x2c,%esp
8010061c:	5b                   	pop    %ebx
8010061d:	5e                   	pop    %esi
8010061e:	5f                   	pop    %edi
8010061f:	5d                   	pop    %ebp
80100620:	c3                   	ret    
80100621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010062f:	90                   	nop

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100639:	ff 75 08             	pushl  0x8(%ebp)
{
8010063c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
8010063f:	e8 ac 11 00 00       	call   801017f0 <iunlock>
  acquire(&cons.lock);
80100644:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064b:	e8 30 3e 00 00       	call   80104480 <acquire>
  for(i = 0; i < n; i++)
80100650:	83 c4 10             	add    $0x10,%esp
80100653:	85 db                	test   %ebx,%ebx
80100655:	7e 28                	jle    8010067f <consolewrite+0x4f>
80100657:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010065a:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
8010065d:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100663:	85 d2                	test   %edx,%edx
80100665:	74 09                	je     80100670 <consolewrite+0x40>
80100667:	fa                   	cli    
    for(;;)
80100668:	eb fe                	jmp    80100668 <consolewrite+0x38>
8010066a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100670:	0f b6 07             	movzbl (%edi),%eax
80100673:	83 c7 01             	add    $0x1,%edi
80100676:	e8 85 fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
8010067b:	39 fe                	cmp    %edi,%esi
8010067d:	75 de                	jne    8010065d <consolewrite+0x2d>
  release(&cons.lock);
8010067f:	83 ec 0c             	sub    $0xc,%esp
80100682:	68 20 a5 10 80       	push   $0x8010a520
80100687:	e8 14 3f 00 00       	call   801045a0 <release>
  ilock(ip);
8010068c:	58                   	pop    %eax
8010068d:	ff 75 08             	pushl  0x8(%ebp)
80100690:	e8 7b 10 00 00       	call   80101710 <ilock>

  return n;
}
80100695:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100698:	89 d8                	mov    %ebx,%eax
8010069a:	5b                   	pop    %ebx
8010069b:	5e                   	pop    %esi
8010069c:	5f                   	pop    %edi
8010069d:	5d                   	pop    %ebp
8010069e:	c3                   	ret    
8010069f:	90                   	nop

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 e4 00 00 00    	jne    8010079d <cprintf+0xfd>
  if (fmt == 0)
801006b9:	8b 45 08             	mov    0x8(%ebp),%eax
801006bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006bf:	85 c0                	test   %eax,%eax
801006c1:	0f 84 5e 01 00 00    	je     80100825 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c7:	0f b6 00             	movzbl (%eax),%eax
801006ca:	85 c0                	test   %eax,%eax
801006cc:	74 32                	je     80100700 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006ce:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006d3:	83 f8 25             	cmp    $0x25,%eax
801006d6:	74 40                	je     80100718 <cprintf+0x78>
  if(panicked){
801006d8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006de:	85 c9                	test   %ecx,%ecx
801006e0:	74 0b                	je     801006ed <cprintf+0x4d>
801006e2:	fa                   	cli    
    for(;;)
801006e3:	eb fe                	jmp    801006e3 <cprintf+0x43>
801006e5:	8d 76 00             	lea    0x0(%esi),%esi
801006e8:	b8 25 00 00 00       	mov    $0x25,%eax
801006ed:	e8 0e fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006f5:	83 c6 01             	add    $0x1,%esi
801006f8:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
801006fc:	85 c0                	test   %eax,%eax
801006fe:	75 d3                	jne    801006d3 <cprintf+0x33>
  if(locking)
80100700:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100703:	85 c0                	test   %eax,%eax
80100705:	0f 85 05 01 00 00    	jne    80100810 <cprintf+0x170>
}
8010070b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010070e:	5b                   	pop    %ebx
8010070f:	5e                   	pop    %esi
80100710:	5f                   	pop    %edi
80100711:	5d                   	pop    %ebp
80100712:	c3                   	ret    
80100713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100717:	90                   	nop
    c = fmt[++i] & 0xff;
80100718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010071b:	83 c6 01             	add    $0x1,%esi
8010071e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100722:	85 ff                	test   %edi,%edi
80100724:	74 da                	je     80100700 <cprintf+0x60>
    switch(c){
80100726:	83 ff 70             	cmp    $0x70,%edi
80100729:	74 5a                	je     80100785 <cprintf+0xe5>
8010072b:	7f 2a                	jg     80100757 <cprintf+0xb7>
8010072d:	83 ff 25             	cmp    $0x25,%edi
80100730:	0f 84 92 00 00 00    	je     801007c8 <cprintf+0x128>
80100736:	83 ff 64             	cmp    $0x64,%edi
80100739:	0f 85 a1 00 00 00    	jne    801007e0 <cprintf+0x140>
      printint(*argp++, 10, 1);
8010073f:	8b 03                	mov    (%ebx),%eax
80100741:	8d 7b 04             	lea    0x4(%ebx),%edi
80100744:	b9 01 00 00 00       	mov    $0x1,%ecx
80100749:	ba 0a 00 00 00       	mov    $0xa,%edx
8010074e:	89 fb                	mov    %edi,%ebx
80100750:	e8 3b fe ff ff       	call   80100590 <printint>
      break;
80100755:	eb 9b                	jmp    801006f2 <cprintf+0x52>
    switch(c){
80100757:	83 ff 73             	cmp    $0x73,%edi
8010075a:	75 24                	jne    80100780 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010075c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075f:	8b 1b                	mov    (%ebx),%ebx
80100761:	85 db                	test   %ebx,%ebx
80100763:	75 55                	jne    801007ba <cprintf+0x11a>
        s = "(null)";
80100765:	bb 18 70 10 80       	mov    $0x80107018,%ebx
      for(; *s; s++)
8010076a:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
8010076f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100775:	85 d2                	test   %edx,%edx
80100777:	74 39                	je     801007b2 <cprintf+0x112>
80100779:	fa                   	cli    
    for(;;)
8010077a:	eb fe                	jmp    8010077a <cprintf+0xda>
8010077c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100780:	83 ff 78             	cmp    $0x78,%edi
80100783:	75 5b                	jne    801007e0 <cprintf+0x140>
      printint(*argp++, 16, 0);
80100785:	8b 03                	mov    (%ebx),%eax
80100787:	8d 7b 04             	lea    0x4(%ebx),%edi
8010078a:	31 c9                	xor    %ecx,%ecx
8010078c:	ba 10 00 00 00       	mov    $0x10,%edx
80100791:	89 fb                	mov    %edi,%ebx
80100793:	e8 f8 fd ff ff       	call   80100590 <printint>
      break;
80100798:	e9 55 ff ff ff       	jmp    801006f2 <cprintf+0x52>
    acquire(&cons.lock);
8010079d:	83 ec 0c             	sub    $0xc,%esp
801007a0:	68 20 a5 10 80       	push   $0x8010a520
801007a5:	e8 d6 3c 00 00       	call   80104480 <acquire>
801007aa:	83 c4 10             	add    $0x10,%esp
801007ad:	e9 07 ff ff ff       	jmp    801006b9 <cprintf+0x19>
801007b2:	e8 49 fc ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
801007b7:	83 c3 01             	add    $0x1,%ebx
801007ba:	0f be 03             	movsbl (%ebx),%eax
801007bd:	84 c0                	test   %al,%al
801007bf:	75 ae                	jne    8010076f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007c1:	89 fb                	mov    %edi,%ebx
801007c3:	e9 2a ff ff ff       	jmp    801006f2 <cprintf+0x52>
  if(panicked){
801007c8:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007ce:	85 ff                	test   %edi,%edi
801007d0:	0f 84 12 ff ff ff    	je     801006e8 <cprintf+0x48>
801007d6:	fa                   	cli    
    for(;;)
801007d7:	eb fe                	jmp    801007d7 <cprintf+0x137>
801007d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007e0:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007e6:	85 c9                	test   %ecx,%ecx
801007e8:	74 06                	je     801007f0 <cprintf+0x150>
801007ea:	fa                   	cli    
    for(;;)
801007eb:	eb fe                	jmp    801007eb <cprintf+0x14b>
801007ed:	8d 76 00             	lea    0x0(%esi),%esi
801007f0:	b8 25 00 00 00       	mov    $0x25,%eax
801007f5:	e8 06 fc ff ff       	call   80100400 <consputc.part.0>
  if(panicked){
801007fa:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100800:	85 d2                	test   %edx,%edx
80100802:	74 34                	je     80100838 <cprintf+0x198>
80100804:	fa                   	cli    
    for(;;)
80100805:	eb fe                	jmp    80100805 <cprintf+0x165>
80100807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010080e:	66 90                	xchg   %ax,%ax
    release(&cons.lock);
80100810:	83 ec 0c             	sub    $0xc,%esp
80100813:	68 20 a5 10 80       	push   $0x8010a520
80100818:	e8 83 3d 00 00       	call   801045a0 <release>
8010081d:	83 c4 10             	add    $0x10,%esp
}
80100820:	e9 e6 fe ff ff       	jmp    8010070b <cprintf+0x6b>
    panic("null fmt");
80100825:	83 ec 0c             	sub    $0xc,%esp
80100828:	68 1f 70 10 80       	push   $0x8010701f
8010082d:	e8 4e fb ff ff       	call   80100380 <panic>
80100832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100838:	89 f8                	mov    %edi,%eax
8010083a:	e8 c1 fb ff ff       	call   80100400 <consputc.part.0>
8010083f:	e9 ae fe ff ff       	jmp    801006f2 <cprintf+0x52>
80100844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010084b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010084f:	90                   	nop

80100850 <consoleintr>:
{
80100850:	55                   	push   %ebp
80100851:	89 e5                	mov    %esp,%ebp
80100853:	57                   	push   %edi
80100854:	56                   	push   %esi
  int c, doprocdump = 0;
80100855:	31 f6                	xor    %esi,%esi
{
80100857:	53                   	push   %ebx
80100858:	83 ec 18             	sub    $0x18,%esp
8010085b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010085e:	68 20 a5 10 80       	push   $0x8010a520
80100863:	e8 18 3c 00 00       	call   80104480 <acquire>
  while((c = getc()) >= 0){
80100868:	83 c4 10             	add    $0x10,%esp
8010086b:	eb 17                	jmp    80100884 <consoleintr+0x34>
    switch(c){
8010086d:	83 fb 08             	cmp    $0x8,%ebx
80100870:	0f 84 fa 00 00 00    	je     80100970 <consoleintr+0x120>
80100876:	83 fb 10             	cmp    $0x10,%ebx
80100879:	0f 85 19 01 00 00    	jne    80100998 <consoleintr+0x148>
8010087f:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100884:	ff d7                	call   *%edi
80100886:	89 c3                	mov    %eax,%ebx
80100888:	85 c0                	test   %eax,%eax
8010088a:	0f 88 27 01 00 00    	js     801009b7 <consoleintr+0x167>
    switch(c){
80100890:	83 fb 15             	cmp    $0x15,%ebx
80100893:	74 7b                	je     80100910 <consoleintr+0xc0>
80100895:	7e d6                	jle    8010086d <consoleintr+0x1d>
80100897:	83 fb 7f             	cmp    $0x7f,%ebx
8010089a:	0f 84 d0 00 00 00    	je     80100970 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a5:	89 c2                	mov    %eax,%edx
801008a7:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ad:	83 fa 7f             	cmp    $0x7f,%edx
801008b0:	77 d2                	ja     80100884 <consoleintr+0x34>
        c = (c == '\r') ? '\n' : c;
801008b2:	8d 48 01             	lea    0x1(%eax),%ecx
801008b5:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008bb:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008be:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008c4:	83 fb 0d             	cmp    $0xd,%ebx
801008c7:	0f 84 06 01 00 00    	je     801009d3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008cd:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008d3:	85 d2                	test   %edx,%edx
801008d5:	0f 85 03 01 00 00    	jne    801009de <consoleintr+0x18e>
801008db:	89 d8                	mov    %ebx,%eax
801008dd:	e8 1e fb ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e2:	83 fb 0a             	cmp    $0xa,%ebx
801008e5:	0f 84 13 01 00 00    	je     801009fe <consoleintr+0x1ae>
801008eb:	83 fb 04             	cmp    $0x4,%ebx
801008ee:	0f 84 0a 01 00 00    	je     801009fe <consoleintr+0x1ae>
801008f4:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008f9:	83 e8 80             	sub    $0xffffff80,%eax
801008fc:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100902:	75 80                	jne    80100884 <consoleintr+0x34>
80100904:	e9 fa 00 00 00       	jmp    80100a03 <consoleintr+0x1b3>
80100909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100910:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100915:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010091b:	0f 84 63 ff ff ff    	je     80100884 <consoleintr+0x34>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100921:	83 e8 01             	sub    $0x1,%eax
80100924:	89 c2                	mov    %eax,%edx
80100926:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100929:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100930:	0f 84 4e ff ff ff    	je     80100884 <consoleintr+0x34>
  if(panicked){
80100936:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010093c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100941:	85 d2                	test   %edx,%edx
80100943:	74 0b                	je     80100950 <consoleintr+0x100>
80100945:	fa                   	cli    
    for(;;)
80100946:	eb fe                	jmp    80100946 <consoleintr+0xf6>
80100948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010094f:	90                   	nop
80100950:	b8 00 01 00 00       	mov    $0x100,%eax
80100955:	e8 a6 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010095a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100965:	75 ba                	jne    80100921 <consoleintr+0xd1>
80100967:	e9 18 ff ff ff       	jmp    80100884 <consoleintr+0x34>
8010096c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100970:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100975:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010097b:	0f 84 03 ff ff ff    	je     80100884 <consoleintr+0x34>
        input.e--;
80100981:	83 e8 01             	sub    $0x1,%eax
80100984:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100989:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010098e:	85 c0                	test   %eax,%eax
80100990:	74 16                	je     801009a8 <consoleintr+0x158>
80100992:	fa                   	cli    
    for(;;)
80100993:	eb fe                	jmp    80100993 <consoleintr+0x143>
80100995:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100998:	85 db                	test   %ebx,%ebx
8010099a:	0f 84 e4 fe ff ff    	je     80100884 <consoleintr+0x34>
801009a0:	e9 fb fe ff ff       	jmp    801008a0 <consoleintr+0x50>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
801009b2:	e9 cd fe ff ff       	jmp    80100884 <consoleintr+0x34>
  release(&cons.lock);
801009b7:	83 ec 0c             	sub    $0xc,%esp
801009ba:	68 20 a5 10 80       	push   $0x8010a520
801009bf:	e8 dc 3b 00 00       	call   801045a0 <release>
  if(doprocdump) {
801009c4:	83 c4 10             	add    $0x10,%esp
801009c7:	85 f6                	test   %esi,%esi
801009c9:	75 1d                	jne    801009e8 <consoleintr+0x198>
}
801009cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ce:	5b                   	pop    %ebx
801009cf:	5e                   	pop    %esi
801009d0:	5f                   	pop    %edi
801009d1:	5d                   	pop    %ebp
801009d2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009d3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009da:	85 d2                	test   %edx,%edx
801009dc:	74 16                	je     801009f4 <consoleintr+0x1a4>
801009de:	fa                   	cli    
    for(;;)
801009df:	eb fe                	jmp    801009df <consoleintr+0x18f>
801009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009eb:	5b                   	pop    %ebx
801009ec:	5e                   	pop    %esi
801009ed:	5f                   	pop    %edi
801009ee:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ef:	e9 9c 36 00 00       	jmp    80104090 <procdump>
801009f4:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f9:	e8 02 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fe:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a03:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a06:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a0b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a10:	e8 9b 35 00 00       	call   80103fb0 <wakeup>
80100a15:	83 c4 10             	add    $0x10,%esp
80100a18:	e9 67 fe ff ff       	jmp    80100884 <consoleintr+0x34>
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi

80100a20 <consoleinit>:

void
consoleinit(void)
{
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a26:	68 28 70 10 80       	push   $0x80107028
80100a2b:	68 20 a5 10 80       	push   $0x8010a520
80100a30:	e8 4b 39 00 00       	call   80104380 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a35:	58                   	pop    %eax
80100a36:	5a                   	pop    %edx
80100a37:	6a 00                	push   $0x0
80100a39:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a3b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a42:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a45:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a4c:	02 10 80 
  cons.locking = 1;
80100a4f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a56:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a59:	e8 32 19 00 00       	call   80102390 <ioapicenable>
}
80100a5e:	83 c4 10             	add    $0x10,%esp
80100a61:	c9                   	leave  
80100a62:	c3                   	ret    
80100a63:	66 90                	xchg   %ax,%ax
80100a65:	66 90                	xchg   %ax,%ax
80100a67:	66 90                	xchg   %ax,%ax
80100a69:	66 90                	xchg   %ax,%ax
80100a6b:	66 90                	xchg   %ax,%ax
80100a6d:	66 90                	xchg   %ax,%ax
80100a6f:	90                   	nop

80100a70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	57                   	push   %edi
80100a74:	56                   	push   %esi
80100a75:	53                   	push   %ebx
80100a76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a7c:	e8 df 2d 00 00       	call   80103860 <myproc>
80100a81:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a87:	e8 e4 21 00 00       	call   80102c70 <begin_op>

  if((ip = namei(path)) == 0){
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	pushl  0x8(%ebp)
80100a92:	e8 19 15 00 00       	call   80101fb0 <namei>
80100a97:	83 c4 10             	add    $0x10,%esp
80100a9a:	85 c0                	test   %eax,%eax
80100a9c:	0f 84 02 03 00 00    	je     80100da4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100aa2:	83 ec 0c             	sub    $0xc,%esp
80100aa5:	89 c3                	mov    %eax,%ebx
80100aa7:	50                   	push   %eax
80100aa8:	e8 63 0c 00 00       	call   80101710 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ab3:	6a 34                	push   $0x34
80100ab5:	6a 00                	push   $0x0
80100ab7:	50                   	push   %eax
80100ab8:	53                   	push   %ebx
80100ab9:	e8 32 0f 00 00       	call   801019f0 <readi>
80100abe:	83 c4 20             	add    $0x20,%esp
80100ac1:	83 f8 34             	cmp    $0x34,%eax
80100ac4:	74 22                	je     80100ae8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	53                   	push   %ebx
80100aca:	e8 d1 0e 00 00       	call   801019a0 <iunlockput>
    end_op();
80100acf:	e8 0c 22 00 00       	call   80102ce0 <end_op>
80100ad4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100adf:	5b                   	pop    %ebx
80100ae0:	5e                   	pop    %esi
80100ae1:	5f                   	pop    %edi
80100ae2:	5d                   	pop    %ebp
80100ae3:	c3                   	ret    
80100ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100ae8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aef:	45 4c 46 
80100af2:	75 d2                	jne    80100ac6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100af4:	e8 47 62 00 00       	call   80106d40 <setupkvm>
80100af9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100aff:	85 c0                	test   %eax,%eax
80100b01:	74 c3                	je     80100ac6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b03:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b0a:	00 
80100b0b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b11:	0f 84 ac 02 00 00    	je     80100dc3 <exec+0x353>
  sz = 0;
80100b17:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b1e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b21:	31 ff                	xor    %edi,%edi
80100b23:	e9 8e 00 00 00       	jmp    80100bb6 <exec+0x146>
80100b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b2f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b30:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b37:	75 6c                	jne    80100ba5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b39:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b3f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b45:	0f 82 87 00 00 00    	jb     80100bd2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b4b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b51:	72 7f                	jb     80100bd2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b53:	83 ec 04             	sub    $0x4,%esp
80100b56:	50                   	push   %eax
80100b57:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b5d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b63:	e8 f8 5f 00 00       	call   80106b60 <allocuvm>
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b71:	85 c0                	test   %eax,%eax
80100b73:	74 5d                	je     80100bd2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b75:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b7b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b80:	75 50                	jne    80100bd2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b82:	83 ec 0c             	sub    $0xc,%esp
80100b85:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b8b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b91:	53                   	push   %ebx
80100b92:	50                   	push   %eax
80100b93:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b99:	e8 02 5f 00 00       	call   80106aa0 <loaduvm>
80100b9e:	83 c4 20             	add    $0x20,%esp
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	78 2d                	js     80100bd2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bac:	83 c7 01             	add    $0x1,%edi
80100baf:	83 c6 20             	add    $0x20,%esi
80100bb2:	39 f8                	cmp    %edi,%eax
80100bb4:	7e 3a                	jle    80100bf0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bb6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bbc:	6a 20                	push   $0x20
80100bbe:	56                   	push   %esi
80100bbf:	50                   	push   %eax
80100bc0:	53                   	push   %ebx
80100bc1:	e8 2a 0e 00 00       	call   801019f0 <readi>
80100bc6:	83 c4 10             	add    $0x10,%esp
80100bc9:	83 f8 20             	cmp    $0x20,%eax
80100bcc:	0f 84 5e ff ff ff    	je     80100b30 <exec+0xc0>
    freevm(pgdir);
80100bd2:	83 ec 0c             	sub    $0xc,%esp
80100bd5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bdb:	e8 e0 60 00 00       	call   80106cc0 <freevm>
  if(ip){
80100be0:	83 c4 10             	add    $0x10,%esp
80100be3:	e9 de fe ff ff       	jmp    80100ac6 <exec+0x56>
80100be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bef:	90                   	nop
80100bf0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bf6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100bfc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c02:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c08:	83 ec 0c             	sub    $0xc,%esp
80100c0b:	53                   	push   %ebx
80100c0c:	e8 8f 0d 00 00       	call   801019a0 <iunlockput>
  end_op();
80100c11:	e8 ca 20 00 00       	call   80102ce0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c16:	83 c4 0c             	add    $0xc,%esp
80100c19:	56                   	push   %esi
80100c1a:	57                   	push   %edi
80100c1b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c21:	57                   	push   %edi
80100c22:	e8 39 5f 00 00       	call   80106b60 <allocuvm>
80100c27:	83 c4 10             	add    $0x10,%esp
80100c2a:	89 c6                	mov    %eax,%esi
80100c2c:	85 c0                	test   %eax,%eax
80100c2e:	0f 84 94 00 00 00    	je     80100cc8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c34:	83 ec 08             	sub    $0x8,%esp
80100c37:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c3f:	50                   	push   %eax
80100c40:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c41:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c43:	e8 98 61 00 00       	call   80106de0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c48:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4b:	83 c4 10             	add    $0x10,%esp
80100c4e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c54:	8b 00                	mov    (%eax),%eax
80100c56:	85 c0                	test   %eax,%eax
80100c58:	0f 84 8b 00 00 00    	je     80100ce9 <exec+0x279>
80100c5e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c64:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c6a:	eb 23                	jmp    80100c8f <exec+0x21f>
80100c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c70:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c73:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c7a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c83:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c86:	85 c0                	test   %eax,%eax
80100c88:	74 59                	je     80100ce3 <exec+0x273>
    if(argc >= MAXARG)
80100c8a:	83 ff 20             	cmp    $0x20,%edi
80100c8d:	74 39                	je     80100cc8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c8f:	83 ec 0c             	sub    $0xc,%esp
80100c92:	50                   	push   %eax
80100c93:	e8 58 3b 00 00       	call   801047f0 <strlen>
80100c98:	f7 d0                	not    %eax
80100c9a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c9c:	58                   	pop    %eax
80100c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ca6:	e8 45 3b 00 00       	call   801047f0 <strlen>
80100cab:	83 c0 01             	add    $0x1,%eax
80100cae:	50                   	push   %eax
80100caf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb5:	53                   	push   %ebx
80100cb6:	56                   	push   %esi
80100cb7:	e8 74 62 00 00       	call   80106f30 <copyout>
80100cbc:	83 c4 20             	add    $0x20,%esp
80100cbf:	85 c0                	test   %eax,%eax
80100cc1:	79 ad                	jns    80100c70 <exec+0x200>
80100cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cc7:	90                   	nop
    freevm(pgdir);
80100cc8:	83 ec 0c             	sub    $0xc,%esp
80100ccb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cd1:	e8 ea 5f 00 00       	call   80106cc0 <freevm>
80100cd6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cde:	e9 f9 fd ff ff       	jmp    80100adc <exec+0x6c>
80100ce3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cf0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cf2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cf9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cfd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cff:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d02:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d08:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d0a:	50                   	push   %eax
80100d0b:	52                   	push   %edx
80100d0c:	53                   	push   %ebx
80100d0d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d13:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d1a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d1d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d23:	e8 08 62 00 00       	call   80106f30 <copyout>
80100d28:	83 c4 10             	add    $0x10,%esp
80100d2b:	85 c0                	test   %eax,%eax
80100d2d:	78 99                	js     80100cc8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d2f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d32:	8b 55 08             	mov    0x8(%ebp),%edx
80100d35:	0f b6 00             	movzbl (%eax),%eax
80100d38:	84 c0                	test   %al,%al
80100d3a:	74 13                	je     80100d4f <exec+0x2df>
80100d3c:	89 d1                	mov    %edx,%ecx
80100d3e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d40:	83 c1 01             	add    $0x1,%ecx
80100d43:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d45:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d48:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d4b:	84 c0                	test   %al,%al
80100d4d:	75 f1                	jne    80100d40 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d4f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d55:	83 ec 04             	sub    $0x4,%esp
80100d58:	6a 10                	push   $0x10
80100d5a:	89 f8                	mov    %edi,%eax
80100d5c:	52                   	push   %edx
80100d5d:	83 c0 6c             	add    $0x6c,%eax
80100d60:	50                   	push   %eax
80100d61:	e8 4a 3a 00 00       	call   801047b0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d66:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d6c:	89 f8                	mov    %edi,%eax
80100d6e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d71:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d73:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d76:	89 c1                	mov    %eax,%ecx
80100d78:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d7e:	8b 40 18             	mov    0x18(%eax),%eax
80100d81:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d84:	8b 41 18             	mov    0x18(%ecx),%eax
80100d87:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d8a:	89 0c 24             	mov    %ecx,(%esp)
80100d8d:	e8 7e 5b 00 00       	call   80106910 <switchuvm>
  freevm(oldpgdir);
80100d92:	89 3c 24             	mov    %edi,(%esp)
80100d95:	e8 26 5f 00 00       	call   80106cc0 <freevm>
  return 0;
80100d9a:	83 c4 10             	add    $0x10,%esp
80100d9d:	31 c0                	xor    %eax,%eax
80100d9f:	e9 38 fd ff ff       	jmp    80100adc <exec+0x6c>
    end_op();
80100da4:	e8 37 1f 00 00       	call   80102ce0 <end_op>
    cprintf("exec: fail\n");
80100da9:	83 ec 0c             	sub    $0xc,%esp
80100dac:	68 41 70 10 80       	push   $0x80107041
80100db1:	e8 ea f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dbe:	e9 19 fd ff ff       	jmp    80100adc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dc3:	31 ff                	xor    %edi,%edi
80100dc5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dca:	e9 39 fe ff ff       	jmp    80100c08 <exec+0x198>
80100dcf:	90                   	nop

80100dd0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dd6:	68 4d 70 10 80       	push   $0x8010704d
80100ddb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100de0:	e8 9b 35 00 00       	call   80104380 <initlock>
}
80100de5:	83 c4 10             	add    $0x10,%esp
80100de8:	c9                   	leave  
80100de9:	c3                   	ret    
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100df0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100df4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100df9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dfc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e01:	e8 7a 36 00 00       	call   80104480 <acquire>
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	eb 10                	jmp    80100e1b <filealloc+0x2b>
80100e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e0f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e10:	83 c3 18             	add    $0x18,%ebx
80100e13:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e19:	74 25                	je     80100e40 <filealloc+0x50>
    if(f->ref == 0){
80100e1b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	75 ee                	jne    80100e10 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e22:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e25:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e2c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e31:	e8 6a 37 00 00       	call   801045a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e36:	89 d8                	mov    %ebx,%eax
      return f;
80100e38:	83 c4 10             	add    $0x10,%esp
}
80100e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e3e:	c9                   	leave  
80100e3f:	c3                   	ret    
  release(&ftable.lock);
80100e40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e43:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e45:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e4a:	e8 51 37 00 00       	call   801045a0 <release>
}
80100e4f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e51:	83 c4 10             	add    $0x10,%esp
}
80100e54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e57:	c9                   	leave  
80100e58:	c3                   	ret    
80100e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	53                   	push   %ebx
80100e64:	83 ec 10             	sub    $0x10,%esp
80100e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e6a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e6f:	e8 0c 36 00 00       	call   80104480 <acquire>
  if(f->ref < 1)
80100e74:	8b 43 04             	mov    0x4(%ebx),%eax
80100e77:	83 c4 10             	add    $0x10,%esp
80100e7a:	85 c0                	test   %eax,%eax
80100e7c:	7e 1a                	jle    80100e98 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e7e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e81:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e84:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e87:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e8c:	e8 0f 37 00 00       	call   801045a0 <release>
  return f;
}
80100e91:	89 d8                	mov    %ebx,%eax
80100e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e96:	c9                   	leave  
80100e97:	c3                   	ret    
    panic("filedup");
80100e98:	83 ec 0c             	sub    $0xc,%esp
80100e9b:	68 54 70 10 80       	push   $0x80107054
80100ea0:	e8 db f4 ff ff       	call   80100380 <panic>
80100ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	57                   	push   %edi
80100eb4:	56                   	push   %esi
80100eb5:	53                   	push   %ebx
80100eb6:	83 ec 28             	sub    $0x28,%esp
80100eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ebc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ec1:	e8 ba 35 00 00       	call   80104480 <acquire>
  if(f->ref < 1)
80100ec6:	8b 53 04             	mov    0x4(%ebx),%edx
80100ec9:	83 c4 10             	add    $0x10,%esp
80100ecc:	85 d2                	test   %edx,%edx
80100ece:	0f 8e a5 00 00 00    	jle    80100f79 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ed4:	83 ea 01             	sub    $0x1,%edx
80100ed7:	89 53 04             	mov    %edx,0x4(%ebx)
80100eda:	75 44                	jne    80100f20 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100edc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ee0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ee3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ee5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eeb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100eee:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ef1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ef4:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ef9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100efc:	e8 9f 36 00 00       	call   801045a0 <release>

  if(ff.type == FD_PIPE)
80100f01:	83 c4 10             	add    $0x10,%esp
80100f04:	83 ff 01             	cmp    $0x1,%edi
80100f07:	74 57                	je     80100f60 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f09:	83 ff 02             	cmp    $0x2,%edi
80100f0c:	74 2a                	je     80100f38 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f11:	5b                   	pop    %ebx
80100f12:	5e                   	pop    %esi
80100f13:	5f                   	pop    %edi
80100f14:	5d                   	pop    %ebp
80100f15:	c3                   	ret    
80100f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f1d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f20:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f2a:	5b                   	pop    %ebx
80100f2b:	5e                   	pop    %esi
80100f2c:	5f                   	pop    %edi
80100f2d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f2e:	e9 6d 36 00 00       	jmp    801045a0 <release>
80100f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f37:	90                   	nop
    begin_op();
80100f38:	e8 33 1d 00 00       	call   80102c70 <begin_op>
    iput(ff.ip);
80100f3d:	83 ec 0c             	sub    $0xc,%esp
80100f40:	ff 75 e0             	pushl  -0x20(%ebp)
80100f43:	e8 f8 08 00 00       	call   80101840 <iput>
    end_op();
80100f48:	83 c4 10             	add    $0x10,%esp
}
80100f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4e:	5b                   	pop    %ebx
80100f4f:	5e                   	pop    %esi
80100f50:	5f                   	pop    %edi
80100f51:	5d                   	pop    %ebp
    end_op();
80100f52:	e9 89 1d 00 00       	jmp    80102ce0 <end_op>
80100f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f60:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f64:	83 ec 08             	sub    $0x8,%esp
80100f67:	53                   	push   %ebx
80100f68:	56                   	push   %esi
80100f69:	e8 a2 24 00 00       	call   80103410 <pipeclose>
80100f6e:	83 c4 10             	add    $0x10,%esp
}
80100f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f74:	5b                   	pop    %ebx
80100f75:	5e                   	pop    %esi
80100f76:	5f                   	pop    %edi
80100f77:	5d                   	pop    %ebp
80100f78:	c3                   	ret    
    panic("fileclose");
80100f79:	83 ec 0c             	sub    $0xc,%esp
80100f7c:	68 5c 70 10 80       	push   $0x8010705c
80100f81:	e8 fa f3 ff ff       	call   80100380 <panic>
80100f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f8d:	8d 76 00             	lea    0x0(%esi),%esi

80100f90 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	53                   	push   %ebx
80100f94:	83 ec 04             	sub    $0x4,%esp
80100f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f9a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f9d:	75 31                	jne    80100fd0 <filestat+0x40>
    ilock(f->ip);
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	ff 73 10             	pushl  0x10(%ebx)
80100fa5:	e8 66 07 00 00       	call   80101710 <ilock>
    stati(f->ip, st);
80100faa:	58                   	pop    %eax
80100fab:	5a                   	pop    %edx
80100fac:	ff 75 0c             	pushl  0xc(%ebp)
80100faf:	ff 73 10             	pushl  0x10(%ebx)
80100fb2:	e8 09 0a 00 00       	call   801019c0 <stati>
    iunlock(f->ip);
80100fb7:	59                   	pop    %ecx
80100fb8:	ff 73 10             	pushl  0x10(%ebx)
80100fbb:	e8 30 08 00 00       	call   801017f0 <iunlock>
    return 0;
  }
  return -1;
}
80100fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fc3:	83 c4 10             	add    $0x10,%esp
80100fc6:	31 c0                	xor    %eax,%eax
}
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fe0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 0c             	sub    $0xc,%esp
80100fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fec:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100ff2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ff6:	74 60                	je     80101058 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100ff8:	8b 03                	mov    (%ebx),%eax
80100ffa:	83 f8 01             	cmp    $0x1,%eax
80100ffd:	74 41                	je     80101040 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fff:	83 f8 02             	cmp    $0x2,%eax
80101002:	75 5b                	jne    8010105f <fileread+0x7f>
    ilock(f->ip);
80101004:	83 ec 0c             	sub    $0xc,%esp
80101007:	ff 73 10             	pushl  0x10(%ebx)
8010100a:	e8 01 07 00 00       	call   80101710 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010100f:	57                   	push   %edi
80101010:	ff 73 14             	pushl  0x14(%ebx)
80101013:	56                   	push   %esi
80101014:	ff 73 10             	pushl  0x10(%ebx)
80101017:	e8 d4 09 00 00       	call   801019f0 <readi>
8010101c:	83 c4 20             	add    $0x20,%esp
8010101f:	89 c6                	mov    %eax,%esi
80101021:	85 c0                	test   %eax,%eax
80101023:	7e 03                	jle    80101028 <fileread+0x48>
      f->off += r;
80101025:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 bd 07 00 00       	call   801017f0 <iunlock>
    return r;
80101033:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101039:	89 f0                	mov    %esi,%eax
8010103b:	5b                   	pop    %ebx
8010103c:	5e                   	pop    %esi
8010103d:	5f                   	pop    %edi
8010103e:	5d                   	pop    %ebp
8010103f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101040:	8b 43 0c             	mov    0xc(%ebx),%eax
80101043:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	5b                   	pop    %ebx
8010104a:	5e                   	pop    %esi
8010104b:	5f                   	pop    %edi
8010104c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010104d:	e9 5e 25 00 00       	jmp    801035b0 <piperead>
80101052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101058:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010105d:	eb d7                	jmp    80101036 <fileread+0x56>
  panic("fileread");
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	68 66 70 10 80       	push   $0x80107066
80101067:	e8 14 f3 ff ff       	call   80100380 <panic>
8010106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101070 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 1c             	sub    $0x1c,%esp
80101079:	8b 45 0c             	mov    0xc(%ebp),%eax
8010107c:	8b 75 08             	mov    0x8(%ebp),%esi
8010107f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101082:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101085:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101089:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010108c:	0f 84 bd 00 00 00    	je     8010114f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101092:	8b 06                	mov    (%esi),%eax
80101094:	83 f8 01             	cmp    $0x1,%eax
80101097:	0f 84 bf 00 00 00    	je     8010115c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010109d:	83 f8 02             	cmp    $0x2,%eax
801010a0:	0f 85 c8 00 00 00    	jne    8010116e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010a9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 30                	jg     801010df <filewrite+0x6f>
801010af:	e9 94 00 00 00       	jmp    80101148 <filewrite+0xd8>
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010b8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010c4:	e8 27 07 00 00       	call   801017f0 <iunlock>
      end_op();
801010c9:	e8 12 1c 00 00       	call   80102ce0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d1:	83 c4 10             	add    $0x10,%esp
801010d4:	39 c3                	cmp    %eax,%ebx
801010d6:	75 60                	jne    80101138 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010d8:	01 df                	add    %ebx,%edi
    while(i < n){
801010da:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010dd:	7e 69                	jle    80101148 <filewrite+0xd8>
      int n1 = n - i;
801010df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010e2:	b8 00 06 00 00       	mov    $0x600,%eax
801010e7:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801010e9:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010ef:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010f2:	e8 79 1b 00 00       	call   80102c70 <begin_op>
      ilock(f->ip);
801010f7:	83 ec 0c             	sub    $0xc,%esp
801010fa:	ff 76 10             	pushl  0x10(%esi)
801010fd:	e8 0e 06 00 00       	call   80101710 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101102:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101105:	53                   	push   %ebx
80101106:	ff 76 14             	pushl  0x14(%esi)
80101109:	01 f8                	add    %edi,%eax
8010110b:	50                   	push   %eax
8010110c:	ff 76 10             	pushl  0x10(%esi)
8010110f:	e8 dc 09 00 00       	call   80101af0 <writei>
80101114:	83 c4 20             	add    $0x20,%esp
80101117:	85 c0                	test   %eax,%eax
80101119:	7f 9d                	jg     801010b8 <filewrite+0x48>
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	ff 76 10             	pushl  0x10(%esi)
80101121:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101124:	e8 c7 06 00 00       	call   801017f0 <iunlock>
      end_op();
80101129:	e8 b2 1b 00 00       	call   80102ce0 <end_op>
      if(r < 0)
8010112e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	85 c0                	test   %eax,%eax
80101136:	75 17                	jne    8010114f <filewrite+0xdf>
        panic("short filewrite");
80101138:	83 ec 0c             	sub    $0xc,%esp
8010113b:	68 6f 70 10 80       	push   $0x8010706f
80101140:	e8 3b f2 ff ff       	call   80100380 <panic>
80101145:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101148:	89 f8                	mov    %edi,%eax
8010114a:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010114d:	74 05                	je     80101154 <filewrite+0xe4>
8010114f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101157:	5b                   	pop    %ebx
80101158:	5e                   	pop    %esi
80101159:	5f                   	pop    %edi
8010115a:	5d                   	pop    %ebp
8010115b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010115c:	8b 46 0c             	mov    0xc(%esi),%eax
8010115f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101165:	5b                   	pop    %ebx
80101166:	5e                   	pop    %esi
80101167:	5f                   	pop    %edi
80101168:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101169:	e9 42 23 00 00       	jmp    801034b0 <pipewrite>
  panic("filewrite");
8010116e:	83 ec 0c             	sub    $0xc,%esp
80101171:	68 75 70 10 80       	push   $0x80107075
80101176:	e8 05 f2 ff ff       	call   80100380 <panic>
8010117b:	66 90                	xchg   %ax,%ax
8010117d:	66 90                	xchg   %ax,%ax
8010117f:	90                   	nop

80101180 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	83 c4 10             	add    $0x10,%esp
801011be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
801011d2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	89 fa                	mov    %edi,%edx
801011eb:	85 df                	test   %ebx,%edi
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 e4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 7f 70 10 80       	push   $0x8010707f
80101229:	e8 52 f1 ff ff       	call   80100380 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 0e 1c 00 00       	call   80102e50 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 a6 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101255:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101258:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010125a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 86 33 00 00       	call   801045f0 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 de 1b 00 00       	call   80102e50 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 76 ef ff ff       	call   801001f0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010128f:	90                   	nop

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	89 c7                	mov    %eax,%edi
80101296:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101297:	31 f6                	xor    %esi,%esi
{
80101299:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 e0 09 11 80       	push   $0x801109e0
801012aa:	e8 d1 31 00 00       	call   80104480 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801012b2:	83 c4 10             	add    $0x10,%esp
801012b5:	eb 1b                	jmp    801012d2 <iget+0x42>
801012b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012be:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c0:	39 3b                	cmp    %edi,(%ebx)
801012c2:	74 6c                	je     80101330 <iget+0xa0>
801012c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012d0:	73 26                	jae    801012f8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d5:	85 c9                	test   %ecx,%ecx
801012d7:	7f e7                	jg     801012c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e7                	jne    801012c4 <iget+0x34>
801012dd:	89 d8                	mov    %ebx,%eax
801012df:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e5:	85 c9                	test   %ecx,%ecx
801012e7:	75 6e                	jne    80101357 <iget+0xc7>
801012e9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012eb:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012f1:	72 df                	jb     801012d2 <iget+0x42>
801012f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012f7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f8:	85 f6                	test   %esi,%esi
801012fa:	74 73                	je     8010136f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012fc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012ff:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101301:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101304:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010130b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101312:	68 e0 09 11 80       	push   $0x801109e0
80101317:	e8 84 32 00 00       	call   801045a0 <release>

  return ip;
8010131c:	83 c4 10             	add    $0x10,%esp
}
8010131f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101322:	89 f0                	mov    %esi,%eax
80101324:	5b                   	pop    %ebx
80101325:	5e                   	pop    %esi
80101326:	5f                   	pop    %edi
80101327:	5d                   	pop    %ebp
80101328:	c3                   	ret    
80101329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101330:	39 53 04             	cmp    %edx,0x4(%ebx)
80101333:	75 8f                	jne    801012c4 <iget+0x34>
      release(&icache.lock);
80101335:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101338:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010133b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010133d:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101342:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101345:	e8 56 32 00 00       	call   801045a0 <release>
      return ip;
8010134a:	83 c4 10             	add    $0x10,%esp
}
8010134d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101350:	89 f0                	mov    %esi,%eax
80101352:	5b                   	pop    %ebx
80101353:	5e                   	pop    %esi
80101354:	5f                   	pop    %edi
80101355:	5d                   	pop    %ebp
80101356:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101357:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010135d:	73 10                	jae    8010136f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010135f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101362:	85 c9                	test   %ecx,%ecx
80101364:	0f 8f 56 ff ff ff    	jg     801012c0 <iget+0x30>
8010136a:	e9 6e ff ff ff       	jmp    801012dd <iget+0x4d>
    panic("iget: no inodes");
8010136f:	83 ec 0c             	sub    $0xc,%esp
80101372:	68 95 70 10 80       	push   $0x80107095
80101377:	e8 04 f0 ff ff       	call   80100380 <panic>
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	89 c6                	mov    %eax,%esi
80101387:	53                   	push   %ebx
80101388:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010138b:	83 fa 0b             	cmp    $0xb,%edx
8010138e:	0f 86 84 00 00 00    	jbe    80101418 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101394:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101397:	83 fb 7f             	cmp    $0x7f,%ebx
8010139a:	0f 87 98 00 00 00    	ja     80101438 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013a6:	8b 16                	mov    (%esi),%edx
801013a8:	85 c0                	test   %eax,%eax
801013aa:	74 54                	je     80101400 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013ac:	83 ec 08             	sub    $0x8,%esp
801013af:	50                   	push   %eax
801013b0:	52                   	push   %edx
801013b1:	e8 1a ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013b6:	83 c4 10             	add    $0x10,%esp
801013b9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013bd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013bf:	8b 1a                	mov    (%edx),%ebx
801013c1:	85 db                	test   %ebx,%ebx
801013c3:	74 1b                	je     801013e0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	57                   	push   %edi
801013c9:	e8 22 ee ff ff       	call   801001f0 <brelse>
    return addr;
801013ce:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d4:	89 d8                	mov    %ebx,%eax
801013d6:	5b                   	pop    %ebx
801013d7:	5e                   	pop    %esi
801013d8:	5f                   	pop    %edi
801013d9:	5d                   	pop    %ebp
801013da:	c3                   	ret    
801013db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013df:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013e5:	e8 96 fd ff ff       	call   80101180 <balloc>
801013ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013ed:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013f0:	89 c3                	mov    %eax,%ebx
801013f2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013f4:	57                   	push   %edi
801013f5:	e8 56 1a 00 00       	call   80102e50 <log_write>
801013fa:	83 c4 10             	add    $0x10,%esp
801013fd:	eb c6                	jmp    801013c5 <bmap+0x45>
801013ff:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101400:	89 d0                	mov    %edx,%eax
80101402:	e8 79 fd ff ff       	call   80101180 <balloc>
80101407:	8b 16                	mov    (%esi),%edx
80101409:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010140f:	eb 9b                	jmp    801013ac <bmap+0x2c>
80101411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101418:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010141b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010141e:	85 db                	test   %ebx,%ebx
80101420:	75 af                	jne    801013d1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101422:	8b 00                	mov    (%eax),%eax
80101424:	e8 57 fd ff ff       	call   80101180 <balloc>
80101429:	89 47 5c             	mov    %eax,0x5c(%edi)
8010142c:	89 c3                	mov    %eax,%ebx
}
8010142e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101431:	89 d8                	mov    %ebx,%eax
80101433:	5b                   	pop    %ebx
80101434:	5e                   	pop    %esi
80101435:	5f                   	pop    %edi
80101436:	5d                   	pop    %ebp
80101437:	c3                   	ret    
  panic("bmap: out of range");
80101438:	83 ec 0c             	sub    $0xc,%esp
8010143b:	68 a5 70 10 80       	push   $0x801070a5
80101440:	e8 3b ef ff ff       	call   80100380 <panic>
80101445:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101450 <readsb>:
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	56                   	push   %esi
80101454:	53                   	push   %ebx
80101455:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101458:	83 ec 08             	sub    $0x8,%esp
8010145b:	6a 01                	push   $0x1
8010145d:	ff 75 08             	pushl  0x8(%ebp)
80101460:	e8 6b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101465:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101468:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010146a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010146d:	6a 1c                	push   $0x1c
8010146f:	50                   	push   %eax
80101470:	56                   	push   %esi
80101471:	e8 1a 32 00 00       	call   80104690 <memmove>
  brelse(bp);
80101476:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101479:	83 c4 10             	add    $0x10,%esp
}
8010147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147f:	5b                   	pop    %ebx
80101480:	5e                   	pop    %esi
80101481:	5d                   	pop    %ebp
  brelse(bp);
80101482:	e9 69 ed ff ff       	jmp    801001f0 <brelse>
80101487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148e:	66 90                	xchg   %ax,%ax

80101490 <bfree>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	56                   	push   %esi
80101494:	89 c6                	mov    %eax,%esi
80101496:	53                   	push   %ebx
80101497:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
80101499:	83 ec 08             	sub    $0x8,%esp
8010149c:	68 c0 09 11 80       	push   $0x801109c0
801014a1:	50                   	push   %eax
801014a2:	e8 a9 ff ff ff       	call   80101450 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014a7:	58                   	pop    %eax
801014a8:	89 d8                	mov    %ebx,%eax
801014aa:	5a                   	pop    %edx
801014ab:	c1 e8 0c             	shr    $0xc,%eax
801014ae:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801014b4:	50                   	push   %eax
801014b5:	56                   	push   %esi
801014b6:	e8 15 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014bb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014bd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014c0:	ba 01 00 00 00       	mov    $0x1,%edx
801014c5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014c8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014ce:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014d1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014d3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014d8:	85 d1                	test   %edx,%ecx
801014da:	74 25                	je     80101501 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014dc:	f7 d2                	not    %edx
  log_write(bp);
801014de:	83 ec 0c             	sub    $0xc,%esp
801014e1:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801014e3:	21 ca                	and    %ecx,%edx
801014e5:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801014e9:	50                   	push   %eax
801014ea:	e8 61 19 00 00       	call   80102e50 <log_write>
  brelse(bp);
801014ef:	89 34 24             	mov    %esi,(%esp)
801014f2:	e8 f9 ec ff ff       	call   801001f0 <brelse>
}
801014f7:	83 c4 10             	add    $0x10,%esp
801014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014fd:	5b                   	pop    %ebx
801014fe:	5e                   	pop    %esi
801014ff:	5d                   	pop    %ebp
80101500:	c3                   	ret    
    panic("freeing free block");
80101501:	83 ec 0c             	sub    $0xc,%esp
80101504:	68 b8 70 10 80       	push   $0x801070b8
80101509:	e8 72 ee ff ff       	call   80100380 <panic>
8010150e:	66 90                	xchg   %ax,%ax

80101510 <iinit>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	53                   	push   %ebx
80101514:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101519:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010151c:	68 cb 70 10 80       	push   $0x801070cb
80101521:	68 e0 09 11 80       	push   $0x801109e0
80101526:	e8 55 2e 00 00       	call   80104380 <initlock>
  for(i = 0; i < NINODE; i++) {
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101530:	83 ec 08             	sub    $0x8,%esp
80101533:	68 d2 70 10 80       	push   $0x801070d2
80101538:	53                   	push   %ebx
80101539:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010153f:	e8 2c 2d 00 00       	call   80104270 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101544:	83 c4 10             	add    $0x10,%esp
80101547:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010154d:	75 e1                	jne    80101530 <iinit+0x20>
  readsb(dev, &sb);
8010154f:	83 ec 08             	sub    $0x8,%esp
80101552:	68 c0 09 11 80       	push   $0x801109c0
80101557:	ff 75 08             	pushl  0x8(%ebp)
8010155a:	e8 f1 fe ff ff       	call   80101450 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010155f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101565:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010156b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101571:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101577:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010157d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101583:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101589:	68 38 71 10 80       	push   $0x80107138
8010158e:	e8 0d f1 ff ff       	call   801006a0 <cprintf>
}
80101593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101596:	83 c4 30             	add    $0x30,%esp
80101599:	c9                   	leave  
8010159a:	c3                   	ret    
8010159b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010159f:	90                   	nop

801015a0 <ialloc>:
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
801015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015ac:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015b3:	8b 75 08             	mov    0x8(%ebp),%esi
801015b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	0f 86 91 00 00 00    	jbe    80101650 <ialloc+0xb0>
801015bf:	bf 01 00 00 00       	mov    $0x1,%edi
801015c4:	eb 21                	jmp    801015e7 <ialloc+0x47>
801015c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801015d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015d3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801015d6:	53                   	push   %ebx
801015d7:	e8 14 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015dc:	83 c4 10             	add    $0x10,%esp
801015df:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
801015e5:	73 69                	jae    80101650 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015e7:	89 f8                	mov    %edi,%eax
801015e9:	83 ec 08             	sub    $0x8,%esp
801015ec:	c1 e8 03             	shr    $0x3,%eax
801015ef:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015f5:	50                   	push   %eax
801015f6:	56                   	push   %esi
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801015fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801015ff:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101601:	89 f8                	mov    %edi,%eax
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	c1 e0 06             	shl    $0x6,%eax
80101609:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010160d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101611:	75 bd                	jne    801015d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101613:	83 ec 04             	sub    $0x4,%esp
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	6a 40                	push   $0x40
8010161b:	6a 00                	push   $0x0
8010161d:	51                   	push   %ecx
8010161e:	e8 cd 2f 00 00       	call   801045f0 <memset>
      dip->type = type;
80101623:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101627:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010162a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162d:	89 1c 24             	mov    %ebx,(%esp)
80101630:	e8 1b 18 00 00       	call   80102e50 <log_write>
      brelse(bp);
80101635:	89 1c 24             	mov    %ebx,(%esp)
80101638:	e8 b3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010163d:	83 c4 10             	add    $0x10,%esp
}
80101640:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101643:	89 fa                	mov    %edi,%edx
}
80101645:	5b                   	pop    %ebx
      return iget(dev, inum);
80101646:	89 f0                	mov    %esi,%eax
}
80101648:	5e                   	pop    %esi
80101649:	5f                   	pop    %edi
8010164a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010164b:	e9 40 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 d8 70 10 80       	push   $0x801070d8
80101658:	e8 23 ed ff ff       	call   80100380 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101668:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010166e:	83 ec 08             	sub    $0x8,%esp
80101671:	c1 e8 03             	shr    $0x3,%eax
80101674:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010167a:	50                   	push   %eax
8010167b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010167e:	e8 4d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101683:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101687:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010168a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010168c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010168f:	83 e0 07             	and    $0x7,%eax
80101692:	c1 e0 06             	shl    $0x6,%eax
80101695:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101699:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010169c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bd:	6a 34                	push   $0x34
801016bf:	53                   	push   %ebx
801016c0:	50                   	push   %eax
801016c1:	e8 ca 2f 00 00       	call   80104690 <memmove>
  log_write(bp);
801016c6:	89 34 24             	mov    %esi,(%esp)
801016c9:	e8 82 17 00 00       	call   80102e50 <log_write>
  brelse(bp);
801016ce:	89 75 08             	mov    %esi,0x8(%ebp)
801016d1:	83 c4 10             	add    $0x10,%esp
}
801016d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d7:	5b                   	pop    %ebx
801016d8:	5e                   	pop    %esi
801016d9:	5d                   	pop    %ebp
  brelse(bp);
801016da:	e9 11 eb ff ff       	jmp    801001f0 <brelse>
801016df:	90                   	nop

801016e0 <idup>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	83 ec 10             	sub    $0x10,%esp
801016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ea:	68 e0 09 11 80       	push   $0x801109e0
801016ef:	e8 8c 2d 00 00       	call   80104480 <acquire>
  ip->ref++;
801016f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016f8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016ff:	e8 9c 2e 00 00       	call   801045a0 <release>
}
80101704:	89 d8                	mov    %ebx,%eax
80101706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101709:	c9                   	leave  
8010170a:	c3                   	ret    
8010170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010170f:	90                   	nop

80101710 <ilock>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101718:	85 db                	test   %ebx,%ebx
8010171a:	0f 84 b7 00 00 00    	je     801017d7 <ilock+0xc7>
80101720:	8b 53 08             	mov    0x8(%ebx),%edx
80101723:	85 d2                	test   %edx,%edx
80101725:	0f 8e ac 00 00 00    	jle    801017d7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010172b:	83 ec 0c             	sub    $0xc,%esp
8010172e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101731:	50                   	push   %eax
80101732:	e8 79 2b 00 00       	call   801042b0 <acquiresleep>
  if(ip->valid == 0){
80101737:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010173a:	83 c4 10             	add    $0x10,%esp
8010173d:	85 c0                	test   %eax,%eax
8010173f:	74 0f                	je     80101750 <ilock+0x40>
}
80101741:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101744:	5b                   	pop    %ebx
80101745:	5e                   	pop    %esi
80101746:	5d                   	pop    %ebp
80101747:	c3                   	ret    
80101748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101750:	8b 43 04             	mov    0x4(%ebx),%eax
80101753:	83 ec 08             	sub    $0x8,%esp
80101756:	c1 e8 03             	shr    $0x3,%eax
80101759:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010175f:	50                   	push   %eax
80101760:	ff 33                	pushl  (%ebx)
80101762:	e8 69 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 04             	mov    0x4(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101779:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010177c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010177f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101783:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101787:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010178b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010178f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101793:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101797:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010179b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010179e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a1:	6a 34                	push   $0x34
801017a3:	50                   	push   %eax
801017a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017a7:	50                   	push   %eax
801017a8:	e8 e3 2e 00 00       	call   80104690 <memmove>
    brelse(bp);
801017ad:	89 34 24             	mov    %esi,(%esp)
801017b0:	e8 3b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017b5:	83 c4 10             	add    $0x10,%esp
801017b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017c4:	0f 85 77 ff ff ff    	jne    80101741 <ilock+0x31>
      panic("ilock: no type");
801017ca:	83 ec 0c             	sub    $0xc,%esp
801017cd:	68 f0 70 10 80       	push   $0x801070f0
801017d2:	e8 a9 eb ff ff       	call   80100380 <panic>
    panic("ilock");
801017d7:	83 ec 0c             	sub    $0xc,%esp
801017da:	68 ea 70 10 80       	push   $0x801070ea
801017df:	e8 9c eb ff ff       	call   80100380 <panic>
801017e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <iunlock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	74 28                	je     80101824 <iunlock+0x34>
801017fc:	83 ec 0c             	sub    $0xc,%esp
801017ff:	8d 73 0c             	lea    0xc(%ebx),%esi
80101802:	56                   	push   %esi
80101803:	e8 48 2b 00 00       	call   80104350 <holdingsleep>
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 c0                	test   %eax,%eax
8010180d:	74 15                	je     80101824 <iunlock+0x34>
8010180f:	8b 43 08             	mov    0x8(%ebx),%eax
80101812:	85 c0                	test   %eax,%eax
80101814:	7e 0e                	jle    80101824 <iunlock+0x34>
  releasesleep(&ip->lock);
80101816:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101819:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010181f:	e9 ec 2a 00 00       	jmp    80104310 <releasesleep>
    panic("iunlock");
80101824:	83 ec 0c             	sub    $0xc,%esp
80101827:	68 ff 70 10 80       	push   $0x801070ff
8010182c:	e8 4f eb ff ff       	call   80100380 <panic>
80101831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iput>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 28             	sub    $0x28,%esp
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010184c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010184f:	57                   	push   %edi
80101850:	e8 5b 2a 00 00       	call   801042b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101855:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101858:	83 c4 10             	add    $0x10,%esp
8010185b:	85 d2                	test   %edx,%edx
8010185d:	74 07                	je     80101866 <iput+0x26>
8010185f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101864:	74 32                	je     80101898 <iput+0x58>
  releasesleep(&ip->lock);
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	57                   	push   %edi
8010186a:	e8 a1 2a 00 00       	call   80104310 <releasesleep>
  acquire(&icache.lock);
8010186f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101876:	e8 05 2c 00 00       	call   80104480 <acquire>
  ip->ref--;
8010187b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010187f:	83 c4 10             	add    $0x10,%esp
80101882:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5f                   	pop    %edi
8010188f:	5d                   	pop    %ebp
  release(&icache.lock);
80101890:	e9 0b 2d 00 00       	jmp    801045a0 <release>
80101895:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 e0 09 11 80       	push   $0x801109e0
801018a0:	e8 db 2b 00 00       	call   80104480 <acquire>
    int r = ip->ref;
801018a5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018a8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018af:	e8 ec 2c 00 00       	call   801045a0 <release>
    if(r == 1){
801018b4:	83 c4 10             	add    $0x10,%esp
801018b7:	83 fe 01             	cmp    $0x1,%esi
801018ba:	75 aa                	jne    80101866 <iput+0x26>
801018bc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018c8:	89 cf                	mov    %ecx,%edi
801018ca:	eb 0b                	jmp    801018d7 <iput+0x97>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018d0:	83 c6 04             	add    $0x4,%esi
801018d3:	39 fe                	cmp    %edi,%esi
801018d5:	74 19                	je     801018f0 <iput+0xb0>
    if(ip->addrs[i]){
801018d7:	8b 16                	mov    (%esi),%edx
801018d9:	85 d2                	test   %edx,%edx
801018db:	74 f3                	je     801018d0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018dd:	8b 03                	mov    (%ebx),%eax
801018df:	e8 ac fb ff ff       	call   80101490 <bfree>
      ip->addrs[i] = 0;
801018e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018ea:	eb e4                	jmp    801018d0 <iput+0x90>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018f0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018f9:	85 c0                	test   %eax,%eax
801018fb:	75 33                	jne    80101930 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018fd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101900:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101907:	53                   	push   %ebx
80101908:	e8 53 fd ff ff       	call   80101660 <iupdate>
      ip->type = 0;
8010190d:	31 c0                	xor    %eax,%eax
8010190f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101913:	89 1c 24             	mov    %ebx,(%esp)
80101916:	e8 45 fd ff ff       	call   80101660 <iupdate>
      ip->valid = 0;
8010191b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101922:	83 c4 10             	add    $0x10,%esp
80101925:	e9 3c ff ff ff       	jmp    80101866 <iput+0x26>
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101930:	83 ec 08             	sub    $0x8,%esp
80101933:	50                   	push   %eax
80101934:	ff 33                	pushl  (%ebx)
80101936:	e8 95 e7 ff ff       	call   801000d0 <bread>
8010193b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010193e:	83 c4 10             	add    $0x10,%esp
80101941:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101947:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010194a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010194d:	89 cf                	mov    %ecx,%edi
8010194f:	eb 0e                	jmp    8010195f <iput+0x11f>
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101958:	83 c6 04             	add    $0x4,%esi
8010195b:	39 f7                	cmp    %esi,%edi
8010195d:	74 11                	je     80101970 <iput+0x130>
      if(a[j])
8010195f:	8b 16                	mov    (%esi),%edx
80101961:	85 d2                	test   %edx,%edx
80101963:	74 f3                	je     80101958 <iput+0x118>
        bfree(ip->dev, a[j]);
80101965:	8b 03                	mov    (%ebx),%eax
80101967:	e8 24 fb ff ff       	call   80101490 <bfree>
8010196c:	eb ea                	jmp    80101958 <iput+0x118>
8010196e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101970:	83 ec 0c             	sub    $0xc,%esp
80101973:	ff 75 e4             	pushl  -0x1c(%ebp)
80101976:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101979:	e8 72 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010197e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101984:	8b 03                	mov    (%ebx),%eax
80101986:	e8 05 fb ff ff       	call   80101490 <bfree>
    ip->addrs[NDIRECT] = 0;
8010198b:	83 c4 10             	add    $0x10,%esp
8010198e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101995:	00 00 00 
80101998:	e9 60 ff ff ff       	jmp    801018fd <iput+0xbd>
8010199d:	8d 76 00             	lea    0x0(%esi),%esi

801019a0 <iunlockput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	53                   	push   %ebx
801019a4:	83 ec 10             	sub    $0x10,%esp
801019a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019aa:	53                   	push   %ebx
801019ab:	e8 40 fe ff ff       	call   801017f0 <iunlock>
  iput(ip);
801019b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019b3:	83 c4 10             	add    $0x10,%esp
}
801019b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019b9:	c9                   	leave  
  iput(ip);
801019ba:	e9 81 fe ff ff       	jmp    80101840 <iput>
801019bf:	90                   	nop

801019c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	8b 55 08             	mov    0x8(%ebp),%edx
801019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019c9:	8b 0a                	mov    (%edx),%ecx
801019cb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801019d1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019d4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019d8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019db:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019df:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019e3:	8b 52 58             	mov    0x58(%edx),%edx
801019e6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019e9:	5d                   	pop    %ebp
801019ea:	c3                   	ret    
801019eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ef:	90                   	nop

801019f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
801019f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	8b 75 10             	mov    0x10(%ebp),%esi
80101a02:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a05:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a08:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a13:	0f 84 a7 00 00 00    	je     80101ac0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a1c:	8b 40 58             	mov    0x58(%eax),%eax
80101a1f:	39 c6                	cmp    %eax,%esi
80101a21:	0f 87 ba 00 00 00    	ja     80101ae1 <readi+0xf1>
80101a27:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a2a:	31 c9                	xor    %ecx,%ecx
80101a2c:	89 da                	mov    %ebx,%edx
80101a2e:	01 f2                	add    %esi,%edx
80101a30:	0f 92 c1             	setb   %cl
80101a33:	89 cf                	mov    %ecx,%edi
80101a35:	0f 82 a6 00 00 00    	jb     80101ae1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a3b:	89 c1                	mov    %eax,%ecx
80101a3d:	29 f1                	sub    %esi,%ecx
80101a3f:	39 d0                	cmp    %edx,%eax
80101a41:	0f 43 cb             	cmovae %ebx,%ecx
80101a44:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	85 c9                	test   %ecx,%ecx
80101a49:	74 67                	je     80101ab2 <readi+0xc2>
80101a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a53:	89 f2                	mov    %esi,%edx
80101a55:	c1 ea 09             	shr    $0x9,%edx
80101a58:	89 d8                	mov    %ebx,%eax
80101a5a:	e8 21 f9 ff ff       	call   80101380 <bmap>
80101a5f:	83 ec 08             	sub    $0x8,%esp
80101a62:	50                   	push   %eax
80101a63:	ff 33                	pushl  (%ebx)
80101a65:	e8 66 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a72:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a77:	89 f0                	mov    %esi,%eax
80101a79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a7e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a80:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a83:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a85:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a89:	39 d9                	cmp    %ebx,%ecx
80101a8b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a8f:	01 df                	add    %ebx,%edi
80101a91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a93:	50                   	push   %eax
80101a94:	ff 75 e0             	pushl  -0x20(%ebp)
80101a97:	e8 f4 2b 00 00       	call   80104690 <memmove>
    brelse(bp);
80101a9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a9f:	89 14 24             	mov    %edx,(%esp)
80101aa2:	e8 49 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ab0:	77 9e                	ja     80101a50 <readi+0x60>
  }
  return n;
80101ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5f                   	pop    %edi
80101abb:	5d                   	pop    %ebp
80101abc:	c3                   	ret    
80101abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ac0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ac4:	66 83 f8 09          	cmp    $0x9,%ax
80101ac8:	77 17                	ja     80101ae1 <readi+0xf1>
80101aca:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ad1:	85 c0                	test   %eax,%eax
80101ad3:	74 0c                	je     80101ae1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ad5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	5e                   	pop    %esi
80101add:	5f                   	pop    %edi
80101ade:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101adf:	ff e0                	jmp    *%eax
      return -1;
80101ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ae6:	eb cd                	jmp    80101ab5 <readi+0xc5>
80101ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
80101af9:	8b 45 08             	mov    0x8(%ebp),%eax
80101afc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aff:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b10:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 b7 00 00 00    	je     80101bd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1f:	0f 82 e7 00 00 00    	jb     80101c0c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b25:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b28:	89 f8                	mov    %edi,%eax
80101b2a:	01 f0                	add    %esi,%eax
80101b2c:	0f 82 da 00 00 00    	jb     80101c0c <writei+0x11c>
80101b32:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b37:	0f 87 cf 00 00 00    	ja     80101c0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b44:	85 ff                	test   %edi,%edi
80101b46:	74 79                	je     80101bc1 <writei+0xd1>
80101b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 f8                	mov    %edi,%eax
80101b5a:	e8 21 f8 ff ff       	call   80101380 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 37                	pushl  (%edi)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b72:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b75:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	89 f0                	mov    %esi,%eax
80101b79:	83 c4 0c             	add    $0xc,%esp
80101b7c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b81:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b83:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	39 d9                	cmp    %ebx,%ecx
80101b89:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b8c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b8d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b8f:	ff 75 dc             	pushl  -0x24(%ebp)
80101b92:	50                   	push   %eax
80101b93:	e8 f8 2a 00 00       	call   80104690 <memmove>
    log_write(bp);
80101b98:	89 3c 24             	mov    %edi,(%esp)
80101b9b:	e8 b0 12 00 00       	call   80102e50 <log_write>
    brelse(bp);
80101ba0:	89 3c 24             	mov    %edi,(%esp)
80101ba3:	e8 48 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ba8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bab:	83 c4 10             	add    $0x10,%esp
80101bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bb1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bb7:	77 97                	ja     80101b50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	77 37                	ja     80101bf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc7:	5b                   	pop    %ebx
80101bc8:	5e                   	pop    %esi
80101bc9:	5f                   	pop    %edi
80101bca:	5d                   	pop    %ebp
80101bcb:	c3                   	ret    
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bd4:	66 83 f8 09          	cmp    $0x9,%ax
80101bd8:	77 32                	ja     80101c0c <writei+0x11c>
80101bda:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101be1:	85 c0                	test   %eax,%eax
80101be3:	74 27                	je     80101c0c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101be5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bef:	ff e0                	jmp    *%eax
80101bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101bf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c01:	50                   	push   %eax
80101c02:	e8 59 fa ff ff       	call   80101660 <iupdate>
80101c07:	83 c4 10             	add    $0x10,%esp
80101c0a:	eb b5                	jmp    80101bc1 <writei+0xd1>
      return -1;
80101c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c11:	eb b1                	jmp    80101bc4 <writei+0xd4>
80101c13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c26:	6a 0e                	push   $0xe
80101c28:	ff 75 0c             	pushl  0xc(%ebp)
80101c2b:	ff 75 08             	pushl  0x8(%ebp)
80101c2e:	e8 cd 2a 00 00       	call   80104700 <strncmp>
}
80101c33:	c9                   	leave  
80101c34:	c3                   	ret    
80101c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 1c             	sub    $0x1c,%esp
80101c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c51:	0f 85 85 00 00 00    	jne    80101cdc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c57:	8b 53 58             	mov    0x58(%ebx),%edx
80101c5a:	31 ff                	xor    %edi,%edi
80101c5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c5f:	85 d2                	test   %edx,%edx
80101c61:	74 3e                	je     80101ca1 <dirlookup+0x61>
80101c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c67:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c68:	6a 10                	push   $0x10
80101c6a:	57                   	push   %edi
80101c6b:	56                   	push   %esi
80101c6c:	53                   	push   %ebx
80101c6d:	e8 7e fd ff ff       	call   801019f0 <readi>
80101c72:	83 c4 10             	add    $0x10,%esp
80101c75:	83 f8 10             	cmp    $0x10,%eax
80101c78:	75 55                	jne    80101ccf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c7f:	74 18                	je     80101c99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c81:	83 ec 04             	sub    $0x4,%esp
80101c84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c87:	6a 0e                	push   $0xe
80101c89:	50                   	push   %eax
80101c8a:	ff 75 0c             	pushl  0xc(%ebp)
80101c8d:	e8 6e 2a 00 00       	call   80104700 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	85 c0                	test   %eax,%eax
80101c97:	74 17                	je     80101cb0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c99:	83 c7 10             	add    $0x10,%edi
80101c9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c9f:	72 c7                	jb     80101c68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ca4:	31 c0                	xor    %eax,%eax
}
80101ca6:	5b                   	pop    %ebx
80101ca7:	5e                   	pop    %esi
80101ca8:	5f                   	pop    %edi
80101ca9:	5d                   	pop    %ebp
80101caa:	c3                   	ret    
80101cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101caf:	90                   	nop
      if(poff)
80101cb0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cb3:	85 c0                	test   %eax,%eax
80101cb5:	74 05                	je     80101cbc <dirlookup+0x7c>
        *poff = off;
80101cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cc0:	8b 03                	mov    (%ebx),%eax
80101cc2:	e8 c9 f5 ff ff       	call   80101290 <iget>
}
80101cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cca:	5b                   	pop    %ebx
80101ccb:	5e                   	pop    %esi
80101ccc:	5f                   	pop    %edi
80101ccd:	5d                   	pop    %ebp
80101cce:	c3                   	ret    
      panic("dirlookup read");
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	68 19 71 10 80       	push   $0x80107119
80101cd7:	e8 a4 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	68 07 71 10 80       	push   $0x80107107
80101ce4:	e8 97 e6 ff ff       	call   80100380 <panic>
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	89 c3                	mov    %eax,%ebx
80101cf8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cfb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cfe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d04:	0f 84 86 01 00 00    	je     80101e90 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d0a:	e8 51 1b 00 00       	call   80103860 <myproc>
  acquire(&icache.lock);
80101d0f:	83 ec 0c             	sub    $0xc,%esp
80101d12:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d14:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d17:	68 e0 09 11 80       	push   $0x801109e0
80101d1c:	e8 5f 27 00 00       	call   80104480 <acquire>
  ip->ref++;
80101d21:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d25:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d2c:	e8 6f 28 00 00       	call   801045a0 <release>
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	eb 0d                	jmp    80101d43 <namex+0x53>
80101d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d43:	0f b6 07             	movzbl (%edi),%eax
80101d46:	3c 2f                	cmp    $0x2f,%al
80101d48:	74 f6                	je     80101d40 <namex+0x50>
  if(*path == 0)
80101d4a:	84 c0                	test   %al,%al
80101d4c:	0f 84 ee 00 00 00    	je     80101e40 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d52:	0f b6 07             	movzbl (%edi),%eax
80101d55:	84 c0                	test   %al,%al
80101d57:	0f 84 fb 00 00 00    	je     80101e58 <namex+0x168>
80101d5d:	89 fb                	mov    %edi,%ebx
80101d5f:	3c 2f                	cmp    $0x2f,%al
80101d61:	0f 84 f1 00 00 00    	je     80101e58 <namex+0x168>
80101d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6e:	66 90                	xchg   %ax,%ax
80101d70:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101d74:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d77:	3c 2f                	cmp    $0x2f,%al
80101d79:	74 04                	je     80101d7f <namex+0x8f>
80101d7b:	84 c0                	test   %al,%al
80101d7d:	75 f1                	jne    80101d70 <namex+0x80>
  len = path - s;
80101d7f:	89 d8                	mov    %ebx,%eax
80101d81:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d83:	83 f8 0d             	cmp    $0xd,%eax
80101d86:	0f 8e 84 00 00 00    	jle    80101e10 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	6a 0e                	push   $0xe
80101d91:	57                   	push   %edi
    path++;
80101d92:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101d94:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d97:	e8 f4 28 00 00       	call   80104690 <memmove>
80101d9c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101d9f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101da2:	75 0c                	jne    80101db0 <namex+0xc0>
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101da8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dab:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dae:	74 f8                	je     80101da8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101db0:	83 ec 0c             	sub    $0xc,%esp
80101db3:	56                   	push   %esi
80101db4:	e8 57 f9 ff ff       	call   80101710 <ilock>
    if(ip->type != T_DIR){
80101db9:	83 c4 10             	add    $0x10,%esp
80101dbc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dc1:	0f 85 a1 00 00 00    	jne    80101e68 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dca:	85 d2                	test   %edx,%edx
80101dcc:	74 09                	je     80101dd7 <namex+0xe7>
80101dce:	80 3f 00             	cmpb   $0x0,(%edi)
80101dd1:	0f 84 d9 00 00 00    	je     80101eb0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dd7:	83 ec 04             	sub    $0x4,%esp
80101dda:	6a 00                	push   $0x0
80101ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ddf:	56                   	push   %esi
80101de0:	e8 5b fe ff ff       	call   80101c40 <dirlookup>
80101de5:	83 c4 10             	add    $0x10,%esp
80101de8:	89 c3                	mov    %eax,%ebx
80101dea:	85 c0                	test   %eax,%eax
80101dec:	74 7a                	je     80101e68 <namex+0x178>
  iunlock(ip);
80101dee:	83 ec 0c             	sub    $0xc,%esp
80101df1:	56                   	push   %esi
80101df2:	e8 f9 f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101df7:	89 34 24             	mov    %esi,(%esp)
80101dfa:	89 de                	mov    %ebx,%esi
80101dfc:	e8 3f fa ff ff       	call   80101840 <iput>
80101e01:	83 c4 10             	add    $0x10,%esp
80101e04:	e9 3a ff ff ff       	jmp    80101d43 <namex+0x53>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e13:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e16:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e19:	83 ec 04             	sub    $0x4,%esp
80101e1c:	50                   	push   %eax
80101e1d:	57                   	push   %edi
    name[len] = 0;
80101e1e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e20:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e23:	e8 68 28 00 00       	call   80104690 <memmove>
    name[len] = 0;
80101e28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e2b:	83 c4 10             	add    $0x10,%esp
80101e2e:	c6 00 00             	movb   $0x0,(%eax)
80101e31:	e9 69 ff ff ff       	jmp    80101d9f <namex+0xaf>
80101e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 85 00 00 00    	jne    80101ed0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e4e:	89 f0                	mov    %esi,%eax
80101e50:	5b                   	pop    %ebx
80101e51:	5e                   	pop    %esi
80101e52:	5f                   	pop    %edi
80101e53:	5d                   	pop    %ebp
80101e54:	c3                   	ret    
80101e55:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e5b:	89 fb                	mov    %edi,%ebx
80101e5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e60:	31 c0                	xor    %eax,%eax
80101e62:	eb b5                	jmp    80101e19 <namex+0x129>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	56                   	push   %esi
80101e6c:	e8 7f f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101e71:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e74:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e76:	e8 c5 f9 ff ff       	call   80101840 <iput>
      return 0;
80101e7b:	83 c4 10             	add    $0x10,%esp
}
80101e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e81:	89 f0                	mov    %esi,%eax
80101e83:	5b                   	pop    %ebx
80101e84:	5e                   	pop    %esi
80101e85:	5f                   	pop    %edi
80101e86:	5d                   	pop    %ebp
80101e87:	c3                   	ret    
80101e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e8f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101e90:	ba 01 00 00 00       	mov    $0x1,%edx
80101e95:	b8 01 00 00 00       	mov    $0x1,%eax
80101e9a:	89 df                	mov    %ebx,%edi
80101e9c:	e8 ef f3 ff ff       	call   80101290 <iget>
80101ea1:	89 c6                	mov    %eax,%esi
80101ea3:	e9 9b fe ff ff       	jmp    80101d43 <namex+0x53>
80101ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eaf:	90                   	nop
      iunlock(ip);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	56                   	push   %esi
80101eb4:	e8 37 f9 ff ff       	call   801017f0 <iunlock>
      return ip;
80101eb9:	83 c4 10             	add    $0x10,%esp
}
80101ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ebf:	89 f0                	mov    %esi,%eax
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
80101ed3:	56                   	push   %esi
    return 0;
80101ed4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ed6:	e8 65 f9 ff ff       	call   80101840 <iput>
    return 0;
80101edb:	83 c4 10             	add    $0x10,%esp
80101ede:	e9 68 ff ff ff       	jmp    80101e4b <namex+0x15b>
80101ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ef0 <dirlink>:
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	57                   	push   %edi
80101ef4:	56                   	push   %esi
80101ef5:	53                   	push   %ebx
80101ef6:	83 ec 20             	sub    $0x20,%esp
80101ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101efc:	6a 00                	push   $0x0
80101efe:	ff 75 0c             	pushl  0xc(%ebp)
80101f01:	53                   	push   %ebx
80101f02:	e8 39 fd ff ff       	call   80101c40 <dirlookup>
80101f07:	83 c4 10             	add    $0x10,%esp
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 67                	jne    80101f75 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f14:	85 ff                	test   %edi,%edi
80101f16:	74 29                	je     80101f41 <dirlink+0x51>
80101f18:	31 ff                	xor    %edi,%edi
80101f1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f1d:	eb 09                	jmp    80101f28 <dirlink+0x38>
80101f1f:	90                   	nop
80101f20:	83 c7 10             	add    $0x10,%edi
80101f23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f26:	73 19                	jae    80101f41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f28:	6a 10                	push   $0x10
80101f2a:	57                   	push   %edi
80101f2b:	56                   	push   %esi
80101f2c:	53                   	push   %ebx
80101f2d:	e8 be fa ff ff       	call   801019f0 <readi>
80101f32:	83 c4 10             	add    $0x10,%esp
80101f35:	83 f8 10             	cmp    $0x10,%eax
80101f38:	75 4e                	jne    80101f88 <dirlink+0x98>
    if(de.inum == 0)
80101f3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f3f:	75 df                	jne    80101f20 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f41:	83 ec 04             	sub    $0x4,%esp
80101f44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f47:	6a 0e                	push   $0xe
80101f49:	ff 75 0c             	pushl  0xc(%ebp)
80101f4c:	50                   	push   %eax
80101f4d:	e8 fe 27 00 00       	call   80104750 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f52:	6a 10                	push   $0x10
  de.inum = inum;
80101f54:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f57:	57                   	push   %edi
80101f58:	56                   	push   %esi
80101f59:	53                   	push   %ebx
  de.inum = inum;
80101f5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f5e:	e8 8d fb ff ff       	call   80101af0 <writei>
80101f63:	83 c4 20             	add    $0x20,%esp
80101f66:	83 f8 10             	cmp    $0x10,%eax
80101f69:	75 2a                	jne    80101f95 <dirlink+0xa5>
  return 0;
80101f6b:	31 c0                	xor    %eax,%eax
}
80101f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret    
    iput(ip);
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	50                   	push   %eax
80101f79:	e8 c2 f8 ff ff       	call   80101840 <iput>
    return -1;
80101f7e:	83 c4 10             	add    $0x10,%esp
80101f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f86:	eb e5                	jmp    80101f6d <dirlink+0x7d>
      panic("dirlink read");
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	68 28 71 10 80       	push   $0x80107128
80101f90:	e8 eb e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	68 66 77 10 80       	push   $0x80107766
80101f9d:	e8 de e3 ff ff       	call   80100380 <panic>
80101fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fb0 <namei>:

struct inode*
namei(char *path)
{
80101fb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fb1:	31 d2                	xor    %edx,%edx
{
80101fb3:	89 e5                	mov    %esp,%ebp
80101fb5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fbe:	e8 2d fd ff ff       	call   80101cf0 <namex>
}
80101fc3:	c9                   	leave  
80101fc4:	c3                   	ret    
80101fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fd0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fd1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fd6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fde:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fdf:	e9 0c fd ff ff       	jmp    80101cf0 <namex>
80101fe4:	66 90                	xchg   %ax,%ax
80101fe6:	66 90                	xchg   %ax,%ax
80101fe8:	66 90                	xchg   %ax,%ax
80101fea:	66 90                	xchg   %ax,%ax
80101fec:	66 90                	xchg   %ax,%ax
80101fee:	66 90                	xchg   %ax,%ax

80101ff0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101ff9:	85 c0                	test   %eax,%eax
80101ffb:	0f 84 b4 00 00 00    	je     801020b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102001:	8b 70 08             	mov    0x8(%eax),%esi
80102004:	89 c3                	mov    %eax,%ebx
80102006:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010200c:	0f 87 96 00 00 00    	ja     801020a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102012:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010201e:	66 90                	xchg   %ax,%ax
80102020:	89 ca                	mov    %ecx,%edx
80102022:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102023:	83 e0 c0             	and    $0xffffffc0,%eax
80102026:	3c 40                	cmp    $0x40,%al
80102028:	75 f6                	jne    80102020 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010202a:	31 ff                	xor    %edi,%edi
8010202c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102031:	89 f8                	mov    %edi,%eax
80102033:	ee                   	out    %al,(%dx)
80102034:	b8 01 00 00 00       	mov    $0x1,%eax
80102039:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010203e:	ee                   	out    %al,(%dx)
8010203f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102044:	89 f0                	mov    %esi,%eax
80102046:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102047:	89 f0                	mov    %esi,%eax
80102049:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010204e:	c1 f8 08             	sar    $0x8,%eax
80102051:	ee                   	out    %al,(%dx)
80102052:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102057:	89 f8                	mov    %edi,%eax
80102059:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010205a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010205e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102063:	c1 e0 04             	shl    $0x4,%eax
80102066:	83 e0 10             	and    $0x10,%eax
80102069:	83 c8 e0             	or     $0xffffffe0,%eax
8010206c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010206d:	f6 03 04             	testb  $0x4,(%ebx)
80102070:	75 16                	jne    80102088 <idestart+0x98>
80102072:	b8 20 00 00 00       	mov    $0x20,%eax
80102077:	89 ca                	mov    %ecx,%edx
80102079:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010207a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207d:	5b                   	pop    %ebx
8010207e:	5e                   	pop    %esi
8010207f:	5f                   	pop    %edi
80102080:	5d                   	pop    %ebp
80102081:	c3                   	ret    
80102082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102088:	b8 30 00 00 00       	mov    $0x30,%eax
8010208d:	89 ca                	mov    %ecx,%edx
8010208f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102090:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102095:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102098:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010209d:	fc                   	cld    
8010209e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a3:	5b                   	pop    %ebx
801020a4:	5e                   	pop    %esi
801020a5:	5f                   	pop    %edi
801020a6:	5d                   	pop    %ebp
801020a7:	c3                   	ret    
    panic("incorrect blockno");
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	68 94 71 10 80       	push   $0x80107194
801020b0:	e8 cb e2 ff ff       	call   80100380 <panic>
    panic("idestart");
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	68 8b 71 10 80       	push   $0x8010718b
801020bd:	e8 be e2 ff ff       	call   80100380 <panic>
801020c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <ideinit>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020d6:	68 a6 71 10 80       	push   $0x801071a6
801020db:	68 80 a5 10 80       	push   $0x8010a580
801020e0:	e8 9b 22 00 00       	call   80104380 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020e5:	58                   	pop    %eax
801020e6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020eb:	5a                   	pop    %edx
801020ec:	83 e8 01             	sub    $0x1,%eax
801020ef:	50                   	push   %eax
801020f0:	6a 0e                	push   $0xe
801020f2:	e8 99 02 00 00       	call   80102390 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ff:	90                   	nop
80102100:	ec                   	in     (%dx),%al
80102101:	83 e0 c0             	and    $0xffffffc0,%eax
80102104:	3c 40                	cmp    $0x40,%al
80102106:	75 f8                	jne    80102100 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102108:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010210d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102112:	ee                   	out    %al,(%dx)
80102113:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	eb 06                	jmp    80102125 <ideinit+0x55>
8010211f:	90                   	nop
  for(i=0; i<1000; i++){
80102120:	83 e9 01             	sub    $0x1,%ecx
80102123:	74 0f                	je     80102134 <ideinit+0x64>
80102125:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102126:	84 c0                	test   %al,%al
80102128:	74 f6                	je     80102120 <ideinit+0x50>
      havedisk1 = 1;
8010212a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102131:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102134:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102139:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010213e:	ee                   	out    %al,(%dx)
}
8010213f:	c9                   	leave  
80102140:	c3                   	ret    
80102141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010214f:	90                   	nop

80102150 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	57                   	push   %edi
80102154:	56                   	push   %esi
80102155:	53                   	push   %ebx
80102156:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102159:	68 80 a5 10 80       	push   $0x8010a580
8010215e:	e8 1d 23 00 00       	call   80104480 <acquire>

  if((b = idequeue) == 0){
80102163:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102169:	83 c4 10             	add    $0x10,%esp
8010216c:	85 db                	test   %ebx,%ebx
8010216e:	74 63                	je     801021d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102170:	8b 43 58             	mov    0x58(%ebx),%eax
80102173:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102178:	8b 33                	mov    (%ebx),%esi
8010217a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102180:	75 2f                	jne    801021b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218e:	66 90                	xchg   %ax,%ax
80102190:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102191:	89 c1                	mov    %eax,%ecx
80102193:	83 e1 c0             	and    $0xffffffc0,%ecx
80102196:	80 f9 40             	cmp    $0x40,%cl
80102199:	75 f5                	jne    80102190 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010219b:	a8 21                	test   $0x21,%al
8010219d:	75 12                	jne    801021b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010219f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ac:	fc                   	cld    
801021ad:	f3 6d                	rep insl (%dx),%es:(%edi)
801021af:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021b7:	83 ce 02             	or     $0x2,%esi
801021ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021bc:	53                   	push   %ebx
801021bd:	e8 ee 1d 00 00       	call   80103fb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021c2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	85 c0                	test   %eax,%eax
801021cc:	74 05                	je     801021d3 <ideintr+0x83>
    idestart(idequeue);
801021ce:	e8 1d fe ff ff       	call   80101ff0 <idestart>
    release(&idelock);
801021d3:	83 ec 0c             	sub    $0xc,%esp
801021d6:	68 80 a5 10 80       	push   $0x8010a580
801021db:	e8 c0 23 00 00       	call   801045a0 <release>

  release(&idelock);
}
801021e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e3:	5b                   	pop    %ebx
801021e4:	5e                   	pop    %esi
801021e5:	5f                   	pop    %edi
801021e6:	5d                   	pop    %ebp
801021e7:	c3                   	ret    
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	53                   	push   %ebx
801021f4:	83 ec 10             	sub    $0x10,%esp
801021f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801021fd:	50                   	push   %eax
801021fe:	e8 4d 21 00 00       	call   80104350 <holdingsleep>
80102203:	83 c4 10             	add    $0x10,%esp
80102206:	85 c0                	test   %eax,%eax
80102208:	0f 84 c3 00 00 00    	je     801022d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010220e:	8b 03                	mov    (%ebx),%eax
80102210:	83 e0 06             	and    $0x6,%eax
80102213:	83 f8 02             	cmp    $0x2,%eax
80102216:	0f 84 a8 00 00 00    	je     801022c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010221c:	8b 53 04             	mov    0x4(%ebx),%edx
8010221f:	85 d2                	test   %edx,%edx
80102221:	74 0d                	je     80102230 <iderw+0x40>
80102223:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102228:	85 c0                	test   %eax,%eax
8010222a:	0f 84 87 00 00 00    	je     801022b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	68 80 a5 10 80       	push   $0x8010a580
80102238:	e8 43 22 00 00       	call   80104480 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010223d:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102242:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 c0                	test   %eax,%eax
8010224e:	74 60                	je     801022b0 <iderw+0xc0>
80102250:	89 c2                	mov    %eax,%edx
80102252:	8b 40 58             	mov    0x58(%eax),%eax
80102255:	85 c0                	test   %eax,%eax
80102257:	75 f7                	jne    80102250 <iderw+0x60>
80102259:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010225c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010225e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102264:	74 3a                	je     801022a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102266:	8b 03                	mov    (%ebx),%eax
80102268:	83 e0 06             	and    $0x6,%eax
8010226b:	83 f8 02             	cmp    $0x2,%eax
8010226e:	74 1b                	je     8010228b <iderw+0x9b>
    sleep(b, &idelock);
80102270:	83 ec 08             	sub    $0x8,%esp
80102273:	68 80 a5 10 80       	push   $0x8010a580
80102278:	53                   	push   %ebx
80102279:	e8 82 1b 00 00       	call   80103e00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010227e:	8b 03                	mov    (%ebx),%eax
80102280:	83 c4 10             	add    $0x10,%esp
80102283:	83 e0 06             	and    $0x6,%eax
80102286:	83 f8 02             	cmp    $0x2,%eax
80102289:	75 e5                	jne    80102270 <iderw+0x80>
  }


  release(&idelock);
8010228b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102295:	c9                   	leave  
  release(&idelock);
80102296:	e9 05 23 00 00       	jmp    801045a0 <release>
8010229b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010229f:	90                   	nop
    idestart(b);
801022a0:	89 d8                	mov    %ebx,%eax
801022a2:	e8 49 fd ff ff       	call   80101ff0 <idestart>
801022a7:	eb bd                	jmp    80102266 <iderw+0x76>
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022b0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022b5:	eb a5                	jmp    8010225c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801022b7:	83 ec 0c             	sub    $0xc,%esp
801022ba:	68 d5 71 10 80       	push   $0x801071d5
801022bf:	e8 bc e0 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 c0 71 10 80       	push   $0x801071c0
801022cc:	e8 af e0 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801022d1:	83 ec 0c             	sub    $0xc,%esp
801022d4:	68 aa 71 10 80       	push   $0x801071aa
801022d9:	e8 a2 e0 ff ff       	call   80100380 <panic>
801022de:	66 90                	xchg   %ax,%ax

801022e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022e8:	00 c0 fe 
{
801022eb:	89 e5                	mov    %esp,%ebp
801022ed:	56                   	push   %esi
801022ee:	53                   	push   %ebx
  ioapic->reg = reg;
801022ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022f6:	00 00 00 
  return ioapic->data;
801022f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102302:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102308:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010230e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102315:	c1 ee 10             	shr    $0x10,%esi
80102318:	89 f0                	mov    %esi,%eax
8010231a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010231d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102320:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102323:	39 c2                	cmp    %eax,%edx
80102325:	74 16                	je     8010233d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102327:	83 ec 0c             	sub    $0xc,%esp
8010232a:	68 f4 71 10 80       	push   $0x801071f4
8010232f:	e8 6c e3 ff ff       	call   801006a0 <cprintf>
80102334:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010233a:	83 c4 10             	add    $0x10,%esp
8010233d:	83 c6 21             	add    $0x21,%esi
{
80102340:	ba 10 00 00 00       	mov    $0x10,%edx
80102345:	b8 20 00 00 00       	mov    $0x20,%eax
8010234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102350:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102352:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102354:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010235a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010235d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102363:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102366:	8d 5a 01             	lea    0x1(%edx),%ebx
80102369:	83 c2 02             	add    $0x2,%edx
8010236c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010236e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102374:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010237b:	39 f0                	cmp    %esi,%eax
8010237d:	75 d1                	jne    80102350 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010237f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102382:	5b                   	pop    %ebx
80102383:	5e                   	pop    %esi
80102384:	5d                   	pop    %ebp
80102385:	c3                   	ret    
80102386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238d:	8d 76 00             	lea    0x0(%esi),%esi

80102390 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102390:	55                   	push   %ebp
  ioapic->reg = reg;
80102391:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102397:	89 e5                	mov    %esp,%ebp
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010239c:	8d 50 20             	lea    0x20(%eax),%edx
8010239f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023b6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023be:	89 50 10             	mov    %edx,0x10(%eax)
}
801023c1:	5d                   	pop    %ebp
801023c2:	c3                   	ret    
801023c3:	66 90                	xchg   %ax,%ax
801023c5:	66 90                	xchg   %ax,%ax
801023c7:	66 90                	xchg   %ax,%ax
801023c9:	66 90                	xchg   %ax,%ax
801023cb:	66 90                	xchg   %ax,%ax
801023cd:	66 90                	xchg   %ax,%ax
801023cf:	90                   	nop

801023d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 04             	sub    $0x4,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023e0:	75 76                	jne    80102458 <kfree+0x88>
801023e2:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801023e8:	72 6e                	jb     80102458 <kfree+0x88>
801023ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023f5:	77 61                	ja     80102458 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023f7:	83 ec 04             	sub    $0x4,%esp
801023fa:	68 00 10 00 00       	push   $0x1000
801023ff:	6a 01                	push   $0x1
80102401:	53                   	push   %ebx
80102402:	e8 e9 21 00 00       	call   801045f0 <memset>

  if(kmem.use_lock)
80102407:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	85 d2                	test   %edx,%edx
80102412:	75 1c                	jne    80102430 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102414:	a1 78 26 11 80       	mov    0x80112678,%eax
80102419:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010241b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102420:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102426:	85 c0                	test   %eax,%eax
80102428:	75 1e                	jne    80102448 <kfree+0x78>
    release(&kmem.lock);
}
8010242a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010242d:	c9                   	leave  
8010242e:	c3                   	ret    
8010242f:	90                   	nop
    acquire(&kmem.lock);
80102430:	83 ec 0c             	sub    $0xc,%esp
80102433:	68 40 26 11 80       	push   $0x80112640
80102438:	e8 43 20 00 00       	call   80104480 <acquire>
8010243d:	83 c4 10             	add    $0x10,%esp
80102440:	eb d2                	jmp    80102414 <kfree+0x44>
80102442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102448:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010244f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102452:	c9                   	leave  
    release(&kmem.lock);
80102453:	e9 48 21 00 00       	jmp    801045a0 <release>
    panic("kfree");
80102458:	83 ec 0c             	sub    $0xc,%esp
8010245b:	68 26 72 10 80       	push   $0x80107226
80102460:	e8 1b df ff ff       	call   80100380 <panic>
80102465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102470 <freerange>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102474:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102477:	8b 75 0c             	mov    0xc(%ebp),%esi
8010247a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <freerange+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 23 ff ff ff       	call   801023d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 f3                	cmp    %esi,%ebx
801024b2:	76 e4                	jbe    80102498 <freerange+0x28>
}
801024b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b7:	5b                   	pop    %ebx
801024b8:	5e                   	pop    %esi
801024b9:	5d                   	pop    %ebp
801024ba:	c3                   	ret    
801024bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024bf:	90                   	nop

801024c0 <kinit1>:
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
801024c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024c8:	83 ec 08             	sub    $0x8,%esp
801024cb:	68 2c 72 10 80       	push   $0x8010722c
801024d0:	68 40 26 11 80       	push   $0x80112640
801024d5:	e8 a6 1e 00 00       	call   80104380 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801024e0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024fc:	39 de                	cmp    %ebx,%esi
801024fe:	72 1c                	jb     8010251c <kinit1+0x5c>
    kfree(p);
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102509:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010250f:	50                   	push   %eax
80102510:	e8 bb fe ff ff       	call   801023d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102515:	83 c4 10             	add    $0x10,%esp
80102518:	39 de                	cmp    %ebx,%esi
8010251a:	73 e4                	jae    80102500 <kinit1+0x40>
}
8010251c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010251f:	5b                   	pop    %ebx
80102520:	5e                   	pop    %esi
80102521:	5d                   	pop    %ebp
80102522:	c3                   	ret    
80102523:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102530 <kinit2>:
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102534:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102537:	8b 75 0c             	mov    0xc(%ebp),%esi
8010253a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010253b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102541:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102547:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010254d:	39 de                	cmp    %ebx,%esi
8010254f:	72 23                	jb     80102574 <kinit2+0x44>
80102551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102567:	50                   	push   %eax
80102568:	e8 63 fe ff ff       	call   801023d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	39 de                	cmp    %ebx,%esi
80102572:	73 e4                	jae    80102558 <kinit2+0x28>
  kmem.use_lock = 1;
80102574:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010257b:	00 00 00 
}
8010257e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102581:	5b                   	pop    %ebx
80102582:	5e                   	pop    %esi
80102583:	5d                   	pop    %ebp
80102584:	c3                   	ret    
80102585:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102590 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102590:	a1 74 26 11 80       	mov    0x80112674,%eax
80102595:	85 c0                	test   %eax,%eax
80102597:	75 1f                	jne    801025b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102599:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010259e:	85 c0                	test   %eax,%eax
801025a0:	74 0e                	je     801025b0 <kalloc+0x20>
    kmem.freelist = r->next;
801025a2:	8b 10                	mov    (%eax),%edx
801025a4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801025b0:	c3                   	ret    
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801025b8:	55                   	push   %ebp
801025b9:	89 e5                	mov    %esp,%ebp
801025bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801025be:	68 40 26 11 80       	push   $0x80112640
801025c3:	e8 b8 1e 00 00       	call   80104480 <acquire>
  r = kmem.freelist;
801025c8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801025cd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025d3:	83 c4 10             	add    $0x10,%esp
801025d6:	85 c0                	test   %eax,%eax
801025d8:	74 08                	je     801025e2 <kalloc+0x52>
    kmem.freelist = r->next;
801025da:	8b 08                	mov    (%eax),%ecx
801025dc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801025e2:	85 d2                	test   %edx,%edx
801025e4:	74 16                	je     801025fc <kalloc+0x6c>
    release(&kmem.lock);
801025e6:	83 ec 0c             	sub    $0xc,%esp
801025e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025ec:	68 40 26 11 80       	push   $0x80112640
801025f1:	e8 aa 1f 00 00       	call   801045a0 <release>
  return (char*)r;
801025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801025f9:	83 c4 10             	add    $0x10,%esp
}
801025fc:	c9                   	leave  
801025fd:	c3                   	ret    
801025fe:	66 90                	xchg   %ax,%ax

80102600 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102600:	ba 64 00 00 00       	mov    $0x64,%edx
80102605:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102606:	a8 01                	test   $0x1,%al
80102608:	0f 84 c2 00 00 00    	je     801026d0 <kbdgetc+0xd0>
{
8010260e:	55                   	push   %ebp
8010260f:	ba 60 00 00 00       	mov    $0x60,%edx
80102614:	89 e5                	mov    %esp,%ebp
80102616:	53                   	push   %ebx
80102617:	ec                   	in     (%dx),%al
  return data;
80102618:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
8010261e:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102621:	3c e0                	cmp    $0xe0,%al
80102623:	74 5b                	je     80102680 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102625:	89 d9                	mov    %ebx,%ecx
80102627:	83 e1 40             	and    $0x40,%ecx
8010262a:	84 c0                	test   %al,%al
8010262c:	78 62                	js     80102690 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010262e:	85 c9                	test   %ecx,%ecx
80102630:	74 09                	je     8010263b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102632:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102635:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102638:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010263b:	0f b6 8a 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%ecx
  shift ^= togglecode[data];
80102642:	0f b6 82 60 72 10 80 	movzbl -0x7fef8da0(%edx),%eax
  shift |= shiftcode[data];
80102649:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010264b:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010264d:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
8010264f:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102655:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102658:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010265b:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
80102662:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102666:	74 0b                	je     80102673 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102668:	8d 50 9f             	lea    -0x61(%eax),%edx
8010266b:	83 fa 19             	cmp    $0x19,%edx
8010266e:	77 48                	ja     801026b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102670:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102673:	5b                   	pop    %ebx
80102674:	5d                   	pop    %ebp
80102675:	c3                   	ret    
80102676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267d:	8d 76 00             	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102680:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102683:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102685:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010268b:	5b                   	pop    %ebx
8010268c:	5d                   	pop    %ebp
8010268d:	c3                   	ret    
8010268e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102690:	83 e0 7f             	and    $0x7f,%eax
80102693:	85 c9                	test   %ecx,%ecx
80102695:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102698:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010269a:	0f b6 8a 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%ecx
801026a1:	83 c9 40             	or     $0x40,%ecx
801026a4:	0f b6 c9             	movzbl %cl,%ecx
801026a7:	f7 d1                	not    %ecx
801026a9:	21 d9                	and    %ebx,%ecx
}
801026ab:	5b                   	pop    %ebx
801026ac:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026ad:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026b3:	c3                   	ret    
801026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801026be:	5b                   	pop    %ebx
801026bf:	5d                   	pop    %ebp
      c += 'a' - 'A';
801026c0:	83 f9 1a             	cmp    $0x1a,%ecx
801026c3:	0f 42 c2             	cmovb  %edx,%eax
}
801026c6:	c3                   	ret    
801026c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ce:	66 90                	xchg   %ax,%ax
    return -1;
801026d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026d5:	c3                   	ret    
801026d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026dd:	8d 76 00             	lea    0x0(%esi),%esi

801026e0 <kbdintr>:

void
kbdintr(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026e6:	68 00 26 10 80       	push   $0x80102600
801026eb:	e8 60 e1 ff ff       	call   80100850 <consoleintr>
}
801026f0:	83 c4 10             	add    $0x10,%esp
801026f3:	c9                   	leave  
801026f4:	c3                   	ret    
801026f5:	66 90                	xchg   %ax,%ax
801026f7:	66 90                	xchg   %ax,%ax
801026f9:	66 90                	xchg   %ax,%ax
801026fb:	66 90                	xchg   %ax,%ax
801026fd:	66 90                	xchg   %ax,%ax
801026ff:	90                   	nop

80102700 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102700:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102705:	85 c0                	test   %eax,%eax
80102707:	0f 84 cb 00 00 00    	je     801027d8 <lapicinit+0xd8>
  lapic[index] = value;
8010270d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102714:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102721:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102727:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010272e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102731:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102734:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010273b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010273e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102741:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102748:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010274b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102755:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102758:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010275b:	8b 50 30             	mov    0x30(%eax),%edx
8010275e:	c1 ea 10             	shr    $0x10,%edx
80102761:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102767:	75 77                	jne    801027e0 <lapicinit+0xe0>
  lapic[index] = value;
80102769:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102770:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102773:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102776:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010277d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102780:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102783:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010278a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010278d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102790:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102797:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010279a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010279d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027b4:	8b 50 20             	mov    0x20(%eax),%edx
801027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027c6:	80 e6 10             	and    $0x10,%dh
801027c9:	75 f5                	jne    801027c0 <lapicinit+0xc0>
  lapic[index] = value;
801027cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027d8:	c3                   	ret    
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801027e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801027ed:	e9 77 ff ff ff       	jmp    80102769 <lapicinit+0x69>
801027f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102800 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102800:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	74 07                	je     80102810 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102809:	8b 40 20             	mov    0x20(%eax),%eax
8010280c:	c1 e8 18             	shr    $0x18,%eax
8010280f:	c3                   	ret    
    return 0;
80102810:	31 c0                	xor    %eax,%eax
}
80102812:	c3                   	ret    
80102813:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102820 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102820:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102825:	85 c0                	test   %eax,%eax
80102827:	74 0d                	je     80102836 <lapiceoi+0x16>
  lapic[index] = value;
80102829:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102830:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102833:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102836:	c3                   	ret    
80102837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283e:	66 90                	xchg   %ax,%ax

80102840 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102840:	c3                   	ret    
80102841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284f:	90                   	nop

80102850 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102850:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102851:	b8 0f 00 00 00       	mov    $0xf,%eax
80102856:	ba 70 00 00 00       	mov    $0x70,%edx
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	53                   	push   %ebx
8010285e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102861:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102864:	ee                   	out    %al,(%dx)
80102865:	b8 0a 00 00 00       	mov    $0xa,%eax
8010286a:	ba 71 00 00 00       	mov    $0x71,%edx
8010286f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102870:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102872:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102875:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010287b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010287d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102880:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102882:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102885:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102888:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010288e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102893:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102899:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010289c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801028d7:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801028d8:	8b 40 20             	mov    0x20(%eax),%eax
}
801028db:	5d                   	pop    %ebp
801028dc:	c3                   	ret    
801028dd:	8d 76 00             	lea    0x0(%esi),%esi

801028e0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028e0:	55                   	push   %ebp
801028e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801028e6:	ba 70 00 00 00       	mov    $0x70,%edx
801028eb:	89 e5                	mov    %esp,%ebp
801028ed:	57                   	push   %edi
801028ee:	56                   	push   %esi
801028ef:	53                   	push   %ebx
801028f0:	83 ec 4c             	sub    $0x4c,%esp
801028f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f4:	ba 71 00 00 00       	mov    $0x71,%edx
801028f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102902:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102905:	8d 76 00             	lea    0x0(%esi),%esi
80102908:	31 c0                	xor    %eax,%eax
8010290a:	89 da                	mov    %ebx,%edx
8010290c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102912:	89 ca                	mov    %ecx,%edx
80102914:	ec                   	in     (%dx),%al
80102915:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102918:	89 da                	mov    %ebx,%edx
8010291a:	b8 02 00 00 00       	mov    $0x2,%eax
8010291f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
80102923:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 da                	mov    %ebx,%edx
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
80102931:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102934:	89 da                	mov    %ebx,%edx
80102936:	b8 07 00 00 00       	mov    $0x7,%eax
8010293b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293c:	89 ca                	mov    %ecx,%edx
8010293e:	ec                   	in     (%dx),%al
8010293f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102942:	89 da                	mov    %ebx,%edx
80102944:	b8 08 00 00 00       	mov    $0x8,%eax
80102949:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294a:	89 ca                	mov    %ecx,%edx
8010294c:	ec                   	in     (%dx),%al
8010294d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010294f:	89 da                	mov    %ebx,%edx
80102951:	b8 09 00 00 00       	mov    $0x9,%eax
80102956:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102957:	89 ca                	mov    %ecx,%edx
80102959:	ec                   	in     (%dx),%al
8010295a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010295c:	89 da                	mov    %ebx,%edx
8010295e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102963:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102964:	89 ca                	mov    %ecx,%edx
80102966:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102967:	84 c0                	test   %al,%al
80102969:	78 9d                	js     80102908 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010296b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010296f:	89 fa                	mov    %edi,%edx
80102971:	0f b6 fa             	movzbl %dl,%edi
80102974:	89 f2                	mov    %esi,%edx
80102976:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102979:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010297d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102980:	89 da                	mov    %ebx,%edx
80102982:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102985:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102988:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010298c:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010298f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102992:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102996:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102999:	31 c0                	xor    %eax,%eax
8010299b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299c:	89 ca                	mov    %ecx,%edx
8010299e:	ec                   	in     (%dx),%al
8010299f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a2:	89 da                	mov    %ebx,%edx
801029a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029a7:	b8 02 00 00 00       	mov    $0x2,%eax
801029ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ad:	89 ca                	mov    %ecx,%edx
801029af:	ec                   	in     (%dx),%al
801029b0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b3:	89 da                	mov    %ebx,%edx
801029b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029b8:	b8 04 00 00 00       	mov    $0x4,%eax
801029bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029be:	89 ca                	mov    %ecx,%edx
801029c0:	ec                   	in     (%dx),%al
801029c1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c4:	89 da                	mov    %ebx,%edx
801029c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029c9:	b8 07 00 00 00       	mov    $0x7,%eax
801029ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cf:	89 ca                	mov    %ecx,%edx
801029d1:	ec                   	in     (%dx),%al
801029d2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d5:	89 da                	mov    %ebx,%edx
801029d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029da:	b8 08 00 00 00       	mov    $0x8,%eax
801029df:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e0:	89 ca                	mov    %ecx,%edx
801029e2:	ec                   	in     (%dx),%al
801029e3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e6:	89 da                	mov    %ebx,%edx
801029e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029eb:	b8 09 00 00 00       	mov    $0x9,%eax
801029f0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f1:	89 ca                	mov    %ecx,%edx
801029f3:	ec                   	in     (%dx),%al
801029f4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029f7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801029fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a00:	6a 18                	push   $0x18
80102a02:	50                   	push   %eax
80102a03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a06:	50                   	push   %eax
80102a07:	e8 34 1c 00 00       	call   80104640 <memcmp>
80102a0c:	83 c4 10             	add    $0x10,%esp
80102a0f:	85 c0                	test   %eax,%eax
80102a11:	0f 85 f1 fe ff ff    	jne    80102908 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a1b:	75 78                	jne    80102a95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a20:	89 c2                	mov    %eax,%edx
80102a22:	83 e0 0f             	and    $0xf,%eax
80102a25:	c1 ea 04             	shr    $0x4,%edx
80102a28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a34:	89 c2                	mov    %eax,%edx
80102a36:	83 e0 0f             	and    $0xf,%eax
80102a39:	c1 ea 04             	shr    $0x4,%edx
80102a3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a48:	89 c2                	mov    %eax,%edx
80102a4a:	83 e0 0f             	and    $0xf,%eax
80102a4d:	c1 ea 04             	shr    $0x4,%edx
80102a50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a5c:	89 c2                	mov    %eax,%edx
80102a5e:	83 e0 0f             	and    $0xf,%eax
80102a61:	c1 ea 04             	shr    $0x4,%edx
80102a64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a70:	89 c2                	mov    %eax,%edx
80102a72:	83 e0 0f             	and    $0xf,%eax
80102a75:	c1 ea 04             	shr    $0x4,%edx
80102a78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a84:	89 c2                	mov    %eax,%edx
80102a86:	83 e0 0f             	and    $0xf,%eax
80102a89:	c1 ea 04             	shr    $0x4,%edx
80102a8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a95:	8b 75 08             	mov    0x8(%ebp),%esi
80102a98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a9b:	89 06                	mov    %eax,(%esi)
80102a9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aa0:	89 46 04             	mov    %eax,0x4(%esi)
80102aa3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102aa6:	89 46 08             	mov    %eax,0x8(%esi)
80102aa9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102aac:	89 46 0c             	mov    %eax,0xc(%esi)
80102aaf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ab2:	89 46 10             	mov    %eax,0x10(%esi)
80102ab5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ab8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102abb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ac5:	5b                   	pop    %ebx
80102ac6:	5e                   	pop    %esi
80102ac7:	5f                   	pop    %edi
80102ac8:	5d                   	pop    %ebp
80102ac9:	c3                   	ret    
80102aca:	66 90                	xchg   %ax,%ax
80102acc:	66 90                	xchg   %ax,%ax
80102ace:	66 90                	xchg   %ax,%ax

80102ad0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ad0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ad6:	85 c9                	test   %ecx,%ecx
80102ad8:	0f 8e 8a 00 00 00    	jle    80102b68 <install_trans+0x98>
{
80102ade:	55                   	push   %ebp
80102adf:	89 e5                	mov    %esp,%ebp
80102ae1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ae2:	31 ff                	xor    %edi,%edi
{
80102ae4:	56                   	push   %esi
80102ae5:	53                   	push   %ebx
80102ae6:	83 ec 0c             	sub    $0xc,%esp
80102ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102af0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102af5:	83 ec 08             	sub    $0x8,%esp
80102af8:	01 f8                	add    %edi,%eax
80102afa:	83 c0 01             	add    $0x1,%eax
80102afd:	50                   	push   %eax
80102afe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b04:	e8 c7 d5 ff ff       	call   801000d0 <bread>
80102b09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b0b:	58                   	pop    %eax
80102b0c:	5a                   	pop    %edx
80102b0d:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102b14:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b1d:	e8 ae d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b2a:	68 00 02 00 00       	push   $0x200
80102b2f:	50                   	push   %eax
80102b30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102b33:	50                   	push   %eax
80102b34:	e8 57 1b 00 00       	call   80104690 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b39:	89 1c 24             	mov    %ebx,(%esp)
80102b3c:	e8 6f d6 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102b41:	89 34 24             	mov    %esi,(%esp)
80102b44:	e8 a7 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102b49:	89 1c 24             	mov    %ebx,(%esp)
80102b4c:	e8 9f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b51:	83 c4 10             	add    $0x10,%esp
80102b54:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102b5a:	7f 94                	jg     80102af0 <install_trans+0x20>
  }
}
80102b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b5f:	5b                   	pop    %ebx
80102b60:	5e                   	pop    %esi
80102b61:	5f                   	pop    %edi
80102b62:	5d                   	pop    %ebp
80102b63:	c3                   	ret    
80102b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b68:	c3                   	ret    
80102b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	53                   	push   %ebx
80102b74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b77:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b7d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b83:	e8 48 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102b8d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102b92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102b95:	85 c0                	test   %eax,%eax
80102b97:	7e 19                	jle    80102bb2 <write_head+0x42>
80102b99:	31 d2                	xor    %edx,%edx
80102b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ba0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102ba7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102bab:	83 c2 01             	add    $0x1,%edx
80102bae:	39 d0                	cmp    %edx,%eax
80102bb0:	75 ee                	jne    80102ba0 <write_head+0x30>
  }
  bwrite(buf);
80102bb2:	83 ec 0c             	sub    $0xc,%esp
80102bb5:	53                   	push   %ebx
80102bb6:	e8 f5 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102bbb:	89 1c 24             	mov    %ebx,(%esp)
80102bbe:	e8 2d d6 ff ff       	call   801001f0 <brelse>
}
80102bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc6:	83 c4 10             	add    $0x10,%esp
80102bc9:	c9                   	leave  
80102bca:	c3                   	ret    
80102bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop

80102bd0 <initlog>:
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	53                   	push   %ebx
80102bd4:	83 ec 2c             	sub    $0x2c,%esp
80102bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102bda:	68 60 74 10 80       	push   $0x80107460
80102bdf:	68 80 26 11 80       	push   $0x80112680
80102be4:	e8 97 17 00 00       	call   80104380 <initlock>
  readsb(dev, &sb);
80102be9:	58                   	pop    %eax
80102bea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102bed:	5a                   	pop    %edx
80102bee:	50                   	push   %eax
80102bef:	53                   	push   %ebx
80102bf0:	e8 5b e8 ff ff       	call   80101450 <readsb>
  log.start = sb.logstart;
80102bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102bf8:	59                   	pop    %ecx
  log.dev = dev;
80102bf9:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102bff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c02:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c07:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c0d:	5a                   	pop    %edx
80102c0e:	50                   	push   %eax
80102c0f:	53                   	push   %ebx
80102c10:	e8 bb d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c18:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c1b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c21:	85 c9                	test   %ecx,%ecx
80102c23:	7e 1d                	jle    80102c42 <initlog+0x72>
80102c25:	31 d2                	xor    %edx,%edx
80102c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c30:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c34:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c3b:	83 c2 01             	add    $0x1,%edx
80102c3e:	39 d1                	cmp    %edx,%ecx
80102c40:	75 ee                	jne    80102c30 <initlog+0x60>
  brelse(buf);
80102c42:	83 ec 0c             	sub    $0xc,%esp
80102c45:	50                   	push   %eax
80102c46:	e8 a5 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c4b:	e8 80 fe ff ff       	call   80102ad0 <install_trans>
  log.lh.n = 0;
80102c50:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c57:	00 00 00 
  write_head(); // clear the log
80102c5a:	e8 11 ff ff ff       	call   80102b70 <write_head>
}
80102c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c62:	83 c4 10             	add    $0x10,%esp
80102c65:	c9                   	leave  
80102c66:	c3                   	ret    
80102c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c76:	68 80 26 11 80       	push   $0x80112680
80102c7b:	e8 00 18 00 00       	call   80104480 <acquire>
80102c80:	83 c4 10             	add    $0x10,%esp
80102c83:	eb 18                	jmp    80102c9d <begin_op+0x2d>
80102c85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c88:	83 ec 08             	sub    $0x8,%esp
80102c8b:	68 80 26 11 80       	push   $0x80112680
80102c90:	68 80 26 11 80       	push   $0x80112680
80102c95:	e8 66 11 00 00       	call   80103e00 <sleep>
80102c9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c9d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102ca2:	85 c0                	test   %eax,%eax
80102ca4:	75 e2                	jne    80102c88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ca6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cab:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cb1:	83 c0 01             	add    $0x1,%eax
80102cb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102cb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cba:	83 fa 1e             	cmp    $0x1e,%edx
80102cbd:	7f c9                	jg     80102c88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102cbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102cc2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102cc7:	68 80 26 11 80       	push   $0x80112680
80102ccc:	e8 cf 18 00 00       	call   801045a0 <release>
      break;
    }
  }
}
80102cd1:	83 c4 10             	add    $0x10,%esp
80102cd4:	c9                   	leave  
80102cd5:	c3                   	ret    
80102cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cdd:	8d 76 00             	lea    0x0(%esi),%esi

80102ce0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	57                   	push   %edi
80102ce4:	56                   	push   %esi
80102ce5:	53                   	push   %ebx
80102ce6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ce9:	68 80 26 11 80       	push   $0x80112680
80102cee:	e8 8d 17 00 00       	call   80104480 <acquire>
  log.outstanding -= 1;
80102cf3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102cf8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102cfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d04:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d0a:	85 f6                	test   %esi,%esi
80102d0c:	0f 85 22 01 00 00    	jne    80102e34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d12:	85 db                	test   %ebx,%ebx
80102d14:	0f 85 f6 00 00 00    	jne    80102e10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d1a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d24:	83 ec 0c             	sub    $0xc,%esp
80102d27:	68 80 26 11 80       	push   $0x80112680
80102d2c:	e8 6f 18 00 00       	call   801045a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d31:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d37:	83 c4 10             	add    $0x10,%esp
80102d3a:	85 c9                	test   %ecx,%ecx
80102d3c:	7f 42                	jg     80102d80 <end_op+0xa0>
    acquire(&log.lock);
80102d3e:	83 ec 0c             	sub    $0xc,%esp
80102d41:	68 80 26 11 80       	push   $0x80112680
80102d46:	e8 35 17 00 00       	call   80104480 <acquire>
    wakeup(&log);
80102d4b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d52:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d59:	00 00 00 
    wakeup(&log);
80102d5c:	e8 4f 12 00 00       	call   80103fb0 <wakeup>
    release(&log.lock);
80102d61:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d68:	e8 33 18 00 00       	call   801045a0 <release>
80102d6d:	83 c4 10             	add    $0x10,%esp
}
80102d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d73:	5b                   	pop    %ebx
80102d74:	5e                   	pop    %esi
80102d75:	5f                   	pop    %edi
80102d76:	5d                   	pop    %ebp
80102d77:	c3                   	ret    
80102d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d80:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d85:	83 ec 08             	sub    $0x8,%esp
80102d88:	01 d8                	add    %ebx,%eax
80102d8a:	83 c0 01             	add    $0x1,%eax
80102d8d:	50                   	push   %eax
80102d8e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d94:	e8 37 d3 ff ff       	call   801000d0 <bread>
80102d99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d9b:	58                   	pop    %eax
80102d9c:	5a                   	pop    %edx
80102d9d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102da4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102daa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dad:	e8 1e d3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102db2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102db5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102db7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dba:	68 00 02 00 00       	push   $0x200
80102dbf:	50                   	push   %eax
80102dc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dc3:	50                   	push   %eax
80102dc4:	e8 c7 18 00 00       	call   80104690 <memmove>
    bwrite(to);  // write the log
80102dc9:	89 34 24             	mov    %esi,(%esp)
80102dcc:	e8 df d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102dd1:	89 3c 24             	mov    %edi,(%esp)
80102dd4:	e8 17 d4 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102dd9:	89 34 24             	mov    %esi,(%esp)
80102ddc:	e8 0f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102dea:	7c 94                	jl     80102d80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102dec:	e8 7f fd ff ff       	call   80102b70 <write_head>
    install_trans(); // Now install writes to home locations
80102df1:	e8 da fc ff ff       	call   80102ad0 <install_trans>
    log.lh.n = 0;
80102df6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102dfd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e00:	e8 6b fd ff ff       	call   80102b70 <write_head>
80102e05:	e9 34 ff ff ff       	jmp    80102d3e <end_op+0x5e>
80102e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e10:	83 ec 0c             	sub    $0xc,%esp
80102e13:	68 80 26 11 80       	push   $0x80112680
80102e18:	e8 93 11 00 00       	call   80103fb0 <wakeup>
  release(&log.lock);
80102e1d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e24:	e8 77 17 00 00       	call   801045a0 <release>
80102e29:	83 c4 10             	add    $0x10,%esp
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret    
    panic("log.committing");
80102e34:	83 ec 0c             	sub    $0xc,%esp
80102e37:	68 64 74 10 80       	push   $0x80107464
80102e3c:	e8 3f d5 ff ff       	call   80100380 <panic>
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop

80102e50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e57:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102e5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e60:	83 fa 1d             	cmp    $0x1d,%edx
80102e63:	0f 8f 85 00 00 00    	jg     80102eee <log_write+0x9e>
80102e69:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e6e:	83 e8 01             	sub    $0x1,%eax
80102e71:	39 c2                	cmp    %eax,%edx
80102e73:	7d 79                	jge    80102eee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e75:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e7a:	85 c0                	test   %eax,%eax
80102e7c:	7e 7d                	jle    80102efb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e7e:	83 ec 0c             	sub    $0xc,%esp
80102e81:	68 80 26 11 80       	push   $0x80112680
80102e86:	e8 f5 15 00 00       	call   80104480 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e8b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102e91:	83 c4 10             	add    $0x10,%esp
80102e94:	85 d2                	test   %edx,%edx
80102e96:	7e 4a                	jle    80102ee2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e98:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e9b:	31 c0                	xor    %eax,%eax
80102e9d:	eb 08                	jmp    80102ea7 <log_write+0x57>
80102e9f:	90                   	nop
80102ea0:	83 c0 01             	add    $0x1,%eax
80102ea3:	39 c2                	cmp    %eax,%edx
80102ea5:	74 29                	je     80102ed0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ea7:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102eae:	75 f0                	jne    80102ea0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102eb0:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102eb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102eba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102ebd:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102ec4:	c9                   	leave  
  release(&log.lock);
80102ec5:	e9 d6 16 00 00       	jmp    801045a0 <release>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ed0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102ed7:	83 c2 01             	add    $0x1,%edx
80102eda:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102ee0:	eb d5                	jmp    80102eb7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102ee2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ee5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102eea:	75 cb                	jne    80102eb7 <log_write+0x67>
80102eec:	eb e9                	jmp    80102ed7 <log_write+0x87>
    panic("too big a transaction");
80102eee:	83 ec 0c             	sub    $0xc,%esp
80102ef1:	68 73 74 10 80       	push   $0x80107473
80102ef6:	e8 85 d4 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102efb:	83 ec 0c             	sub    $0xc,%esp
80102efe:	68 89 74 10 80       	push   $0x80107489
80102f03:	e8 78 d4 ff ff       	call   80100380 <panic>
80102f08:	66 90                	xchg   %ax,%ax
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	53                   	push   %ebx
80102f14:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f17:	e8 24 09 00 00       	call   80103840 <cpuid>
80102f1c:	89 c3                	mov    %eax,%ebx
80102f1e:	e8 1d 09 00 00       	call   80103840 <cpuid>
80102f23:	83 ec 04             	sub    $0x4,%esp
80102f26:	53                   	push   %ebx
80102f27:	50                   	push   %eax
80102f28:	68 a4 74 10 80       	push   $0x801074a4
80102f2d:	e8 6e d7 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80102f32:	e8 f9 28 00 00       	call   80105830 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f37:	e8 94 08 00 00       	call   801037d0 <mycpu>
80102f3c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f3e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f43:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f4a:	e8 d1 0b 00 00       	call   80103b20 <scheduler>
80102f4f:	90                   	nop

80102f50 <mpenter>:
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f56:	e8 a5 39 00 00       	call   80106900 <switchkvm>
  seginit();
80102f5b:	e8 10 39 00 00       	call   80106870 <seginit>
  lapicinit();
80102f60:	e8 9b f7 ff ff       	call   80102700 <lapicinit>
  mpmain();
80102f65:	e8 a6 ff ff ff       	call   80102f10 <mpmain>
80102f6a:	66 90                	xchg   %ax,%ax
80102f6c:	66 90                	xchg   %ax,%ax
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <main>:
{
80102f70:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f74:	83 e4 f0             	and    $0xfffffff0,%esp
80102f77:	ff 71 fc             	pushl  -0x4(%ecx)
80102f7a:	55                   	push   %ebp
80102f7b:	89 e5                	mov    %esp,%ebp
80102f7d:	53                   	push   %ebx
80102f7e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f7f:	83 ec 08             	sub    $0x8,%esp
80102f82:	68 00 00 40 80       	push   $0x80400000
80102f87:	68 a8 54 11 80       	push   $0x801154a8
80102f8c:	e8 2f f5 ff ff       	call   801024c0 <kinit1>
  kvmalloc();      // kernel page table
80102f91:	e8 2a 3e 00 00       	call   80106dc0 <kvmalloc>
  mpinit();        // detect other processors
80102f96:	e8 85 01 00 00       	call   80103120 <mpinit>
  lapicinit();     // interrupt controller
80102f9b:	e8 60 f7 ff ff       	call   80102700 <lapicinit>
  seginit();       // segment descriptors
80102fa0:	e8 cb 38 00 00       	call   80106870 <seginit>
  picinit();       // disable pic
80102fa5:	e8 46 03 00 00       	call   801032f0 <picinit>
  ioapicinit();    // another interrupt controller
80102faa:	e8 31 f3 ff ff       	call   801022e0 <ioapicinit>
  consoleinit();   // console hardware
80102faf:	e8 6c da ff ff       	call   80100a20 <consoleinit>
  uartinit();      // serial port
80102fb4:	e8 77 2b 00 00       	call   80105b30 <uartinit>
  pinit();         // process table
80102fb9:	e8 f2 07 00 00       	call   801037b0 <pinit>
  tvinit();        // trap vectors
80102fbe:	e8 ed 27 00 00       	call   801057b0 <tvinit>
  binit();         // buffer cache
80102fc3:	e8 78 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102fc8:	e8 03 de ff ff       	call   80100dd0 <fileinit>
  ideinit();       // disk 
80102fcd:	e8 fe f0 ff ff       	call   801020d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fd2:	83 c4 0c             	add    $0xc,%esp
80102fd5:	68 8a 00 00 00       	push   $0x8a
80102fda:	68 8c a4 10 80       	push   $0x8010a48c
80102fdf:	68 00 70 00 80       	push   $0x80007000
80102fe4:	e8 a7 16 00 00       	call   80104690 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fe9:	83 c4 10             	add    $0x10,%esp
80102fec:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ff3:	00 00 00 
80102ff6:	05 80 27 11 80       	add    $0x80112780,%eax
80102ffb:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103000:	76 7e                	jbe    80103080 <main+0x110>
80103002:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103007:	eb 20                	jmp    80103029 <main+0xb9>
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103010:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103017:	00 00 00 
8010301a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103020:	05 80 27 11 80       	add    $0x80112780,%eax
80103025:	39 c3                	cmp    %eax,%ebx
80103027:	73 57                	jae    80103080 <main+0x110>
    if(c == mycpu())  // We've started already.
80103029:	e8 a2 07 00 00       	call   801037d0 <mycpu>
8010302e:	39 c3                	cmp    %eax,%ebx
80103030:	74 de                	je     80103010 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103032:	e8 59 f5 ff ff       	call   80102590 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103037:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010303a:	c7 05 f8 6f 00 80 50 	movl   $0x80102f50,0x80006ff8
80103041:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103044:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010304b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010304e:	05 00 10 00 00       	add    $0x1000,%eax
80103053:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103058:	0f b6 03             	movzbl (%ebx),%eax
8010305b:	68 00 70 00 00       	push   $0x7000
80103060:	50                   	push   %eax
80103061:	e8 ea f7 ff ff       	call   80102850 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103066:	83 c4 10             	add    $0x10,%esp
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103070:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103076:	85 c0                	test   %eax,%eax
80103078:	74 f6                	je     80103070 <main+0x100>
8010307a:	eb 94                	jmp    80103010 <main+0xa0>
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103080:	83 ec 08             	sub    $0x8,%esp
80103083:	68 00 00 00 8e       	push   $0x8e000000
80103088:	68 00 00 40 80       	push   $0x80400000
8010308d:	e8 9e f4 ff ff       	call   80102530 <kinit2>
  userinit();      // first user process
80103092:	e8 f9 07 00 00       	call   80103890 <userinit>
  mpmain();        // finish this processor's setup
80103097:	e8 74 fe ff ff       	call   80102f10 <mpmain>
8010309c:	66 90                	xchg   %ax,%ax
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	57                   	push   %edi
801030a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030ab:	53                   	push   %ebx
  e = addr+len;
801030ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030b2:	39 de                	cmp    %ebx,%esi
801030b4:	72 10                	jb     801030c6 <mpsearch1+0x26>
801030b6:	eb 50                	jmp    80103108 <mpsearch1+0x68>
801030b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030bf:	90                   	nop
801030c0:	89 fe                	mov    %edi,%esi
801030c2:	39 fb                	cmp    %edi,%ebx
801030c4:	76 42                	jbe    80103108 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030c6:	83 ec 04             	sub    $0x4,%esp
801030c9:	8d 7e 10             	lea    0x10(%esi),%edi
801030cc:	6a 04                	push   $0x4
801030ce:	68 b8 74 10 80       	push   $0x801074b8
801030d3:	56                   	push   %esi
801030d4:	e8 67 15 00 00       	call   80104640 <memcmp>
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	85 c0                	test   %eax,%eax
801030de:	75 e0                	jne    801030c0 <mpsearch1+0x20>
801030e0:	89 f2                	mov    %esi,%edx
801030e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801030e8:	0f b6 0a             	movzbl (%edx),%ecx
801030eb:	83 c2 01             	add    $0x1,%edx
801030ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801030f0:	39 fa                	cmp    %edi,%edx
801030f2:	75 f4                	jne    801030e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030f4:	84 c0                	test   %al,%al
801030f6:	75 c8                	jne    801030c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801030f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030fb:	89 f0                	mov    %esi,%eax
801030fd:	5b                   	pop    %ebx
801030fe:	5e                   	pop    %esi
801030ff:	5f                   	pop    %edi
80103100:	5d                   	pop    %ebp
80103101:	c3                   	ret    
80103102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010310b:	31 f6                	xor    %esi,%esi
}
8010310d:	5b                   	pop    %ebx
8010310e:	89 f0                	mov    %esi,%eax
80103110:	5e                   	pop    %esi
80103111:	5f                   	pop    %edi
80103112:	5d                   	pop    %ebp
80103113:	c3                   	ret    
80103114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010311b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop

80103120 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
80103125:	53                   	push   %ebx
80103126:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103129:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103130:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103137:	c1 e0 08             	shl    $0x8,%eax
8010313a:	09 d0                	or     %edx,%eax
8010313c:	c1 e0 04             	shl    $0x4,%eax
8010313f:	75 1b                	jne    8010315c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103141:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103148:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010314f:	c1 e0 08             	shl    $0x8,%eax
80103152:	09 d0                	or     %edx,%eax
80103154:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103157:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010315c:	ba 00 04 00 00       	mov    $0x400,%edx
80103161:	e8 3a ff ff ff       	call   801030a0 <mpsearch1>
80103166:	89 c6                	mov    %eax,%esi
80103168:	85 c0                	test   %eax,%eax
8010316a:	0f 84 40 01 00 00    	je     801032b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103170:	8b 5e 04             	mov    0x4(%esi),%ebx
80103173:	85 db                	test   %ebx,%ebx
80103175:	0f 84 55 01 00 00    	je     801032d0 <mpinit+0x1b0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010317b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010317e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103184:	6a 04                	push   $0x4
80103186:	68 bd 74 10 80       	push   $0x801074bd
8010318b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010318c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010318f:	e8 ac 14 00 00       	call   80104640 <memcmp>
80103194:	83 c4 10             	add    $0x10,%esp
80103197:	85 c0                	test   %eax,%eax
80103199:	0f 85 31 01 00 00    	jne    801032d0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
8010319f:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031a6:	3c 01                	cmp    $0x1,%al
801031a8:	74 08                	je     801031b2 <mpinit+0x92>
801031aa:	3c 04                	cmp    $0x4,%al
801031ac:	0f 85 1e 01 00 00    	jne    801032d0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801031b2:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801031b9:	66 85 d2             	test   %dx,%dx
801031bc:	74 22                	je     801031e0 <mpinit+0xc0>
801031be:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801031c1:	89 d8                	mov    %ebx,%eax
  sum = 0;
801031c3:	31 d2                	xor    %edx,%edx
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801031cf:	83 c0 01             	add    $0x1,%eax
801031d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801031d4:	39 f8                	cmp    %edi,%eax
801031d6:	75 f0                	jne    801031c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801031d8:	84 d2                	test   %dl,%dl
801031da:	0f 85 f0 00 00 00    	jne    801032d0 <mpinit+0x1b0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801031e0:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031e6:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031eb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801031f1:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801031f8:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103200:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103207:	90                   	nop
80103208:	39 c2                	cmp    %eax,%edx
8010320a:	76 15                	jbe    80103221 <mpinit+0x101>
    switch(*p){
8010320c:	0f b6 08             	movzbl (%eax),%ecx
8010320f:	80 f9 02             	cmp    $0x2,%cl
80103212:	74 54                	je     80103268 <mpinit+0x148>
80103214:	77 3a                	ja     80103250 <mpinit+0x130>
80103216:	84 c9                	test   %cl,%cl
80103218:	74 66                	je     80103280 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010321a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010321d:	39 c2                	cmp    %eax,%edx
8010321f:	77 eb                	ja     8010320c <mpinit+0xec>
80103221:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103224:	85 db                	test   %ebx,%ebx
80103226:	0f 84 b1 00 00 00    	je     801032dd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010322c:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103230:	74 15                	je     80103247 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103232:	b8 70 00 00 00       	mov    $0x70,%eax
80103237:	ba 22 00 00 00       	mov    $0x22,%edx
8010323c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010323d:	ba 23 00 00 00       	mov    $0x23,%edx
80103242:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103243:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103246:	ee                   	out    %al,(%dx)
  }
}
80103247:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324a:	5b                   	pop    %ebx
8010324b:	5e                   	pop    %esi
8010324c:	5f                   	pop    %edi
8010324d:	5d                   	pop    %ebp
8010324e:	c3                   	ret    
8010324f:	90                   	nop
    switch(*p){
80103250:	83 e9 03             	sub    $0x3,%ecx
80103253:	80 f9 01             	cmp    $0x1,%cl
80103256:	76 c2                	jbe    8010321a <mpinit+0xfa>
80103258:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010325f:	eb a7                	jmp    80103208 <mpinit+0xe8>
80103261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103268:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010326c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010326f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103275:	eb 91                	jmp    80103208 <mpinit+0xe8>
80103277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103280:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103286:	83 f9 07             	cmp    $0x7,%ecx
80103289:	7f 19                	jg     801032a4 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010328b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103291:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103295:	83 c1 01             	add    $0x1,%ecx
80103298:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010329e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801032a4:	83 c0 14             	add    $0x14,%eax
      continue;
801032a7:	e9 5c ff ff ff       	jmp    80103208 <mpinit+0xe8>
801032ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801032b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032ba:	e8 e1 fd ff ff       	call   801030a0 <mpsearch1>
801032bf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c1:	85 c0                	test   %eax,%eax
801032c3:	0f 85 a7 fe ff ff    	jne    80103170 <mpinit+0x50>
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801032d0:	83 ec 0c             	sub    $0xc,%esp
801032d3:	68 c2 74 10 80       	push   $0x801074c2
801032d8:	e8 a3 d0 ff ff       	call   80100380 <panic>
    panic("Didn't find a suitable machine");
801032dd:	83 ec 0c             	sub    $0xc,%esp
801032e0:	68 dc 74 10 80       	push   $0x801074dc
801032e5:	e8 96 d0 ff ff       	call   80100380 <panic>
801032ea:	66 90                	xchg   %ax,%ax
801032ec:	66 90                	xchg   %ax,%ax
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <picinit>:
801032f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032f5:	ba 21 00 00 00       	mov    $0x21,%edx
801032fa:	ee                   	out    %al,(%dx)
801032fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103300:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103301:	c3                   	ret    
80103302:	66 90                	xchg   %ax,%ax
80103304:	66 90                	xchg   %ax,%ax
80103306:	66 90                	xchg   %ax,%ax
80103308:	66 90                	xchg   %ax,%ax
8010330a:	66 90                	xchg   %ax,%ax
8010330c:	66 90                	xchg   %ax,%ax
8010330e:	66 90                	xchg   %ax,%ax

80103310 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	57                   	push   %edi
80103314:	56                   	push   %esi
80103315:	53                   	push   %ebx
80103316:	83 ec 0c             	sub    $0xc,%esp
80103319:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010331c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010331f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103325:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010332b:	e8 c0 da ff ff       	call   80100df0 <filealloc>
80103330:	89 03                	mov    %eax,(%ebx)
80103332:	85 c0                	test   %eax,%eax
80103334:	0f 84 a8 00 00 00    	je     801033e2 <pipealloc+0xd2>
8010333a:	e8 b1 da ff ff       	call   80100df0 <filealloc>
8010333f:	89 06                	mov    %eax,(%esi)
80103341:	85 c0                	test   %eax,%eax
80103343:	0f 84 87 00 00 00    	je     801033d0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103349:	e8 42 f2 ff ff       	call   80102590 <kalloc>
8010334e:	89 c7                	mov    %eax,%edi
80103350:	85 c0                	test   %eax,%eax
80103352:	0f 84 b0 00 00 00    	je     80103408 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103358:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010335f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103362:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103365:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010336c:	00 00 00 
  p->nwrite = 0;
8010336f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103376:	00 00 00 
  p->nread = 0;
80103379:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103380:	00 00 00 
  initlock(&p->lock, "pipe");
80103383:	68 fb 74 10 80       	push   $0x801074fb
80103388:	50                   	push   %eax
80103389:	e8 f2 0f 00 00       	call   80104380 <initlock>
  (*f0)->type = FD_PIPE;
8010338e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103390:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103393:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103399:	8b 03                	mov    (%ebx),%eax
8010339b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010339f:	8b 03                	mov    (%ebx),%eax
801033a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033a5:	8b 03                	mov    (%ebx),%eax
801033a7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033aa:	8b 06                	mov    (%esi),%eax
801033ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033b2:	8b 06                	mov    (%esi),%eax
801033b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033b8:	8b 06                	mov    (%esi),%eax
801033ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033be:	8b 06                	mov    (%esi),%eax
801033c0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033c6:	31 c0                	xor    %eax,%eax
}
801033c8:	5b                   	pop    %ebx
801033c9:	5e                   	pop    %esi
801033ca:	5f                   	pop    %edi
801033cb:	5d                   	pop    %ebp
801033cc:	c3                   	ret    
801033cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801033d0:	8b 03                	mov    (%ebx),%eax
801033d2:	85 c0                	test   %eax,%eax
801033d4:	74 1e                	je     801033f4 <pipealloc+0xe4>
    fileclose(*f0);
801033d6:	83 ec 0c             	sub    $0xc,%esp
801033d9:	50                   	push   %eax
801033da:	e8 d1 da ff ff       	call   80100eb0 <fileclose>
801033df:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801033e2:	8b 06                	mov    (%esi),%eax
801033e4:	85 c0                	test   %eax,%eax
801033e6:	74 0c                	je     801033f4 <pipealloc+0xe4>
    fileclose(*f1);
801033e8:	83 ec 0c             	sub    $0xc,%esp
801033eb:	50                   	push   %eax
801033ec:	e8 bf da ff ff       	call   80100eb0 <fileclose>
801033f1:	83 c4 10             	add    $0x10,%esp
}
801033f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801033f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801033fc:	5b                   	pop    %ebx
801033fd:	5e                   	pop    %esi
801033fe:	5f                   	pop    %edi
801033ff:	5d                   	pop    %ebp
80103400:	c3                   	ret    
80103401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103408:	8b 03                	mov    (%ebx),%eax
8010340a:	85 c0                	test   %eax,%eax
8010340c:	75 c8                	jne    801033d6 <pipealloc+0xc6>
8010340e:	eb d2                	jmp    801033e2 <pipealloc+0xd2>

80103410 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	56                   	push   %esi
80103414:	53                   	push   %ebx
80103415:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103418:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010341b:	83 ec 0c             	sub    $0xc,%esp
8010341e:	53                   	push   %ebx
8010341f:	e8 5c 10 00 00       	call   80104480 <acquire>
  if(writable){
80103424:	83 c4 10             	add    $0x10,%esp
80103427:	85 f6                	test   %esi,%esi
80103429:	74 45                	je     80103470 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010342b:	83 ec 0c             	sub    $0xc,%esp
8010342e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103434:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010343b:	00 00 00 
    wakeup(&p->nread);
8010343e:	50                   	push   %eax
8010343f:	e8 6c 0b 00 00       	call   80103fb0 <wakeup>
80103444:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103447:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010344d:	85 d2                	test   %edx,%edx
8010344f:	75 0a                	jne    8010345b <pipeclose+0x4b>
80103451:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103457:	85 c0                	test   %eax,%eax
80103459:	74 35                	je     80103490 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010345b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010345e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103461:	5b                   	pop    %ebx
80103462:	5e                   	pop    %esi
80103463:	5d                   	pop    %ebp
    release(&p->lock);
80103464:	e9 37 11 00 00       	jmp    801045a0 <release>
80103469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103470:	83 ec 0c             	sub    $0xc,%esp
80103473:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103479:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103480:	00 00 00 
    wakeup(&p->nwrite);
80103483:	50                   	push   %eax
80103484:	e8 27 0b 00 00       	call   80103fb0 <wakeup>
80103489:	83 c4 10             	add    $0x10,%esp
8010348c:	eb b9                	jmp    80103447 <pipeclose+0x37>
8010348e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 07 11 00 00       	call   801045a0 <release>
    kfree((char*)p);
80103499:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010349c:	83 c4 10             	add    $0x10,%esp
}
8010349f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a2:	5b                   	pop    %ebx
801034a3:	5e                   	pop    %esi
801034a4:	5d                   	pop    %ebp
    kfree((char*)p);
801034a5:	e9 26 ef ff ff       	jmp    801023d0 <kfree>
801034aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 28             	sub    $0x28,%esp
801034b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034bc:	53                   	push   %ebx
801034bd:	e8 be 0f 00 00       	call   80104480 <acquire>
  for(i = 0; i < n; i++){
801034c2:	8b 45 10             	mov    0x10(%ebp),%eax
801034c5:	83 c4 10             	add    $0x10,%esp
801034c8:	85 c0                	test   %eax,%eax
801034ca:	0f 8e c0 00 00 00    	jle    80103590 <pipewrite+0xe0>
801034d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801034d3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801034df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034e2:	03 45 10             	add    0x10(%ebp),%eax
801034e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034ee:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034f4:	89 ca                	mov    %ecx,%edx
801034f6:	05 00 02 00 00       	add    $0x200,%eax
801034fb:	39 c1                	cmp    %eax,%ecx
801034fd:	74 3f                	je     8010353e <pipewrite+0x8e>
801034ff:	eb 67                	jmp    80103568 <pipewrite+0xb8>
80103501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103508:	e8 53 03 00 00       	call   80103860 <myproc>
8010350d:	8b 48 24             	mov    0x24(%eax),%ecx
80103510:	85 c9                	test   %ecx,%ecx
80103512:	75 34                	jne    80103548 <pipewrite+0x98>
      wakeup(&p->nread);
80103514:	83 ec 0c             	sub    $0xc,%esp
80103517:	57                   	push   %edi
80103518:	e8 93 0a 00 00       	call   80103fb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010351d:	58                   	pop    %eax
8010351e:	5a                   	pop    %edx
8010351f:	53                   	push   %ebx
80103520:	56                   	push   %esi
80103521:	e8 da 08 00 00       	call   80103e00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103526:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103532:	83 c4 10             	add    $0x10,%esp
80103535:	05 00 02 00 00       	add    $0x200,%eax
8010353a:	39 c2                	cmp    %eax,%edx
8010353c:	75 2a                	jne    80103568 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010353e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103544:	85 c0                	test   %eax,%eax
80103546:	75 c0                	jne    80103508 <pipewrite+0x58>
        release(&p->lock);
80103548:	83 ec 0c             	sub    $0xc,%esp
8010354b:	53                   	push   %ebx
8010354c:	e8 4f 10 00 00       	call   801045a0 <release>
        return -1;
80103551:	83 c4 10             	add    $0x10,%esp
80103554:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103559:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010355c:	5b                   	pop    %ebx
8010355d:	5e                   	pop    %esi
8010355e:	5f                   	pop    %edi
8010355f:	5d                   	pop    %ebp
80103560:	c3                   	ret    
80103561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103568:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010356b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010356e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103574:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010357a:	0f b6 06             	movzbl (%esi),%eax
8010357d:	83 c6 01             	add    $0x1,%esi
80103580:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103583:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103587:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010358a:	0f 85 58 ff ff ff    	jne    801034e8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103599:	50                   	push   %eax
8010359a:	e8 11 0a 00 00       	call   80103fb0 <wakeup>
  release(&p->lock);
8010359f:	89 1c 24             	mov    %ebx,(%esp)
801035a2:	e8 f9 0f 00 00       	call   801045a0 <release>
  return n;
801035a7:	8b 45 10             	mov    0x10(%ebp),%eax
801035aa:	83 c4 10             	add    $0x10,%esp
801035ad:	eb aa                	jmp    80103559 <pipewrite+0xa9>
801035af:	90                   	nop

801035b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 18             	sub    $0x18,%esp
801035b9:	8b 75 08             	mov    0x8(%ebp),%esi
801035bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035bf:	56                   	push   %esi
801035c0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035c6:	e8 b5 0e 00 00       	call   80104480 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035cb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035d1:	83 c4 10             	add    $0x10,%esp
801035d4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801035da:	74 2f                	je     8010360b <piperead+0x5b>
801035dc:	eb 37                	jmp    80103615 <piperead+0x65>
801035de:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801035e0:	e8 7b 02 00 00       	call   80103860 <myproc>
801035e5:	8b 48 24             	mov    0x24(%eax),%ecx
801035e8:	85 c9                	test   %ecx,%ecx
801035ea:	0f 85 80 00 00 00    	jne    80103670 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035f0:	83 ec 08             	sub    $0x8,%esp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	e8 06 08 00 00       	call   80103e00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035fa:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103600:	83 c4 10             	add    $0x10,%esp
80103603:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103609:	75 0a                	jne    80103615 <piperead+0x65>
8010360b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103611:	85 c0                	test   %eax,%eax
80103613:	75 cb                	jne    801035e0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103615:	8b 55 10             	mov    0x10(%ebp),%edx
80103618:	31 db                	xor    %ebx,%ebx
8010361a:	85 d2                	test   %edx,%edx
8010361c:	7f 20                	jg     8010363e <piperead+0x8e>
8010361e:	eb 2c                	jmp    8010364c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103620:	8d 48 01             	lea    0x1(%eax),%ecx
80103623:	25 ff 01 00 00       	and    $0x1ff,%eax
80103628:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010362e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103633:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103636:	83 c3 01             	add    $0x1,%ebx
80103639:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010363c:	74 0e                	je     8010364c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010363e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103644:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010364a:	75 d4                	jne    80103620 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010364c:	83 ec 0c             	sub    $0xc,%esp
8010364f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103655:	50                   	push   %eax
80103656:	e8 55 09 00 00       	call   80103fb0 <wakeup>
  release(&p->lock);
8010365b:	89 34 24             	mov    %esi,(%esp)
8010365e:	e8 3d 0f 00 00       	call   801045a0 <release>
  return i;
80103663:	83 c4 10             	add    $0x10,%esp
}
80103666:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103669:	89 d8                	mov    %ebx,%eax
8010366b:	5b                   	pop    %ebx
8010366c:	5e                   	pop    %esi
8010366d:	5f                   	pop    %edi
8010366e:	5d                   	pop    %ebp
8010366f:	c3                   	ret    
      release(&p->lock);
80103670:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103673:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103678:	56                   	push   %esi
80103679:	e8 22 0f 00 00       	call   801045a0 <release>
      return -1;
8010367e:	83 c4 10             	add    $0x10,%esp
}
80103681:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103684:	89 d8                	mov    %ebx,%eax
80103686:	5b                   	pop    %ebx
80103687:	5e                   	pop    %esi
80103688:	5f                   	pop    %edi
80103689:	5d                   	pop    %ebp
8010368a:	c3                   	ret    
8010368b:	66 90                	xchg   %ax,%ax
8010368d:	66 90                	xchg   %ax,%ax
8010368f:	90                   	nop

80103690 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103694:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103699:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010369c:	68 20 2d 11 80       	push   $0x80112d20
801036a1:	e8 da 0d 00 00       	call   80104480 <acquire>
801036a6:	83 c4 10             	add    $0x10,%esp
801036a9:	eb 10                	jmp    801036bb <allocproc+0x2b>
801036ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036b0:	83 c3 7c             	add    $0x7c,%ebx
801036b3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801036b9:	74 75                	je     80103730 <allocproc+0xa0>
    if(p->state == UNUSED)
801036bb:	8b 43 0c             	mov    0xc(%ebx),%eax
801036be:	85 c0                	test   %eax,%eax
801036c0:	75 ee                	jne    801036b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036c2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801036c7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036ca:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036d1:	89 43 10             	mov    %eax,0x10(%ebx)
801036d4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801036d7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801036dc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801036e2:	e8 b9 0e 00 00       	call   801045a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036e7:	e8 a4 ee ff ff       	call   80102590 <kalloc>
801036ec:	83 c4 10             	add    $0x10,%esp
801036ef:	89 43 08             	mov    %eax,0x8(%ebx)
801036f2:	85 c0                	test   %eax,%eax
801036f4:	74 53                	je     80103749 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036f6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036fc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103704:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103707:	c7 40 14 9d 57 10 80 	movl   $0x8010579d,0x14(%eax)
  p->context = (struct context*)sp;
8010370e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103711:	6a 14                	push   $0x14
80103713:	6a 00                	push   $0x0
80103715:	50                   	push   %eax
80103716:	e8 d5 0e 00 00       	call   801045f0 <memset>
  p->context->eip = (uint)forkret;
8010371b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010371e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103721:	c7 40 10 60 37 10 80 	movl   $0x80103760,0x10(%eax)
}
80103728:	89 d8                	mov    %ebx,%eax
8010372a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010372d:	c9                   	leave  
8010372e:	c3                   	ret    
8010372f:	90                   	nop
  release(&ptable.lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103733:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103735:	68 20 2d 11 80       	push   $0x80112d20
8010373a:	e8 61 0e 00 00       	call   801045a0 <release>
}
8010373f:	89 d8                	mov    %ebx,%eax
  return 0;
80103741:	83 c4 10             	add    $0x10,%esp
}
80103744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103747:	c9                   	leave  
80103748:	c3                   	ret    
    p->state = UNUSED;
80103749:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103750:	31 db                	xor    %ebx,%ebx
}
80103752:	89 d8                	mov    %ebx,%eax
80103754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103757:	c9                   	leave  
80103758:	c3                   	ret    
80103759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103760 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103766:	68 20 2d 11 80       	push   $0x80112d20
8010376b:	e8 30 0e 00 00       	call   801045a0 <release>

  if (first) {
80103770:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 c0                	test   %eax,%eax
8010377a:	75 04                	jne    80103780 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010377c:	c9                   	leave  
8010377d:	c3                   	ret    
8010377e:	66 90                	xchg   %ax,%ax
    first = 0;
80103780:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103787:	00 00 00 
    iinit(ROOTDEV);
8010378a:	83 ec 0c             	sub    $0xc,%esp
8010378d:	6a 01                	push   $0x1
8010378f:	e8 7c dd ff ff       	call   80101510 <iinit>
    initlog(ROOTDEV);
80103794:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010379b:	e8 30 f4 ff ff       	call   80102bd0 <initlog>
}
801037a0:	83 c4 10             	add    $0x10,%esp
801037a3:	c9                   	leave  
801037a4:	c3                   	ret    
801037a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037b0 <pinit>:
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037b6:	68 00 75 10 80       	push   $0x80107500
801037bb:	68 20 2d 11 80       	push   $0x80112d20
801037c0:	e8 bb 0b 00 00       	call   80104380 <initlock>
}
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	c9                   	leave  
801037c9:	c3                   	ret    
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037d0 <mycpu>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037d5:	9c                   	pushf  
801037d6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037d7:	f6 c4 02             	test   $0x2,%ah
801037da:	75 4e                	jne    8010382a <mycpu+0x5a>
  apicid = lapicid();
801037dc:	e8 1f f0 ff ff       	call   80102800 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801037e1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
801037e7:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801037e9:	85 f6                	test   %esi,%esi
801037eb:	7e 30                	jle    8010381d <mycpu+0x4d>
801037ed:	31 d2                	xor    %edx,%edx
801037ef:	eb 0e                	jmp    801037ff <mycpu+0x2f>
801037f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f8:	83 c2 01             	add    $0x1,%edx
801037fb:	39 f2                	cmp    %esi,%edx
801037fd:	74 1e                	je     8010381d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801037ff:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103805:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010380c:	39 d8                	cmp    %ebx,%eax
8010380e:	75 e8                	jne    801037f8 <mycpu+0x28>
}
80103810:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103813:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103819:	5b                   	pop    %ebx
8010381a:	5e                   	pop    %esi
8010381b:	5d                   	pop    %ebp
8010381c:	c3                   	ret    
  panic("unknown apicid\n");
8010381d:	83 ec 0c             	sub    $0xc,%esp
80103820:	68 07 75 10 80       	push   $0x80107507
80103825:	e8 56 cb ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
8010382a:	83 ec 0c             	sub    $0xc,%esp
8010382d:	68 3c 76 10 80       	push   $0x8010763c
80103832:	e8 49 cb ff ff       	call   80100380 <panic>
80103837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010383e:	66 90                	xchg   %ax,%ax

80103840 <cpuid>:
cpuid() {
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103846:	e8 85 ff ff ff       	call   801037d0 <mycpu>
}
8010384b:	c9                   	leave  
  return mycpu()-cpus;
8010384c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103851:	c1 f8 04             	sar    $0x4,%eax
80103854:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010385a:	c3                   	ret    
8010385b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010385f:	90                   	nop

80103860 <myproc>:
myproc(void) {
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	53                   	push   %ebx
80103864:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103867:	e8 c4 0b 00 00       	call   80104430 <pushcli>
  c = mycpu();
8010386c:	e8 5f ff ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103871:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103877:	e8 c4 0c 00 00       	call   80104540 <popcli>
}
8010387c:	83 c4 04             	add    $0x4,%esp
8010387f:	89 d8                	mov    %ebx,%eax
80103881:	5b                   	pop    %ebx
80103882:	5d                   	pop    %ebp
80103883:	c3                   	ret    
80103884:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop

80103890 <userinit>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103897:	e8 f4 fd ff ff       	call   80103690 <allocproc>
8010389c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010389e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801038a3:	e8 98 34 00 00       	call   80106d40 <setupkvm>
801038a8:	89 43 04             	mov    %eax,0x4(%ebx)
801038ab:	85 c0                	test   %eax,%eax
801038ad:	0f 84 bd 00 00 00    	je     80103970 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038b3:	83 ec 04             	sub    $0x4,%esp
801038b6:	68 2c 00 00 00       	push   $0x2c
801038bb:	68 60 a4 10 80       	push   $0x8010a460
801038c0:	50                   	push   %eax
801038c1:	e8 5a 31 00 00       	call   80106a20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038cf:	6a 4c                	push   $0x4c
801038d1:	6a 00                	push   $0x0
801038d3:	ff 73 18             	pushl  0x18(%ebx)
801038d6:	e8 15 0d 00 00       	call   801045f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038db:	8b 43 18             	mov    0x18(%ebx),%eax
801038de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038e3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038e6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038ef:	8b 43 18             	mov    0x18(%ebx),%eax
801038f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038f6:	8b 43 18             	mov    0x18(%ebx),%eax
801038f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103901:	8b 43 18             	mov    0x18(%ebx),%eax
80103904:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103908:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010390c:	8b 43 18             	mov    0x18(%ebx),%eax
8010390f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103916:	8b 43 18             	mov    0x18(%ebx),%eax
80103919:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103920:	8b 43 18             	mov    0x18(%ebx),%eax
80103923:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010392a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010392d:	6a 10                	push   $0x10
8010392f:	68 30 75 10 80       	push   $0x80107530
80103934:	50                   	push   %eax
80103935:	e8 76 0e 00 00       	call   801047b0 <safestrcpy>
  p->cwd = namei("/");
8010393a:	c7 04 24 39 75 10 80 	movl   $0x80107539,(%esp)
80103941:	e8 6a e6 ff ff       	call   80101fb0 <namei>
80103946:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103949:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103950:	e8 2b 0b 00 00       	call   80104480 <acquire>
  p->state = RUNNABLE;
80103955:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010395c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103963:	e8 38 0c 00 00       	call   801045a0 <release>
}
80103968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010396b:	83 c4 10             	add    $0x10,%esp
8010396e:	c9                   	leave  
8010396f:	c3                   	ret    
    panic("userinit: out of memory?");
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	68 17 75 10 80       	push   $0x80107517
80103978:	e8 03 ca ff ff       	call   80100380 <panic>
8010397d:	8d 76 00             	lea    0x0(%esi),%esi

80103980 <growproc>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	56                   	push   %esi
80103984:	53                   	push   %ebx
80103985:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103988:	e8 a3 0a 00 00       	call   80104430 <pushcli>
  c = mycpu();
8010398d:	e8 3e fe ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103992:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103998:	e8 a3 0b 00 00       	call   80104540 <popcli>
  sz = curproc->sz;
8010399d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010399f:	85 f6                	test   %esi,%esi
801039a1:	7f 1d                	jg     801039c0 <growproc+0x40>
  } else if(n < 0){
801039a3:	75 3b                	jne    801039e0 <growproc+0x60>
  switchuvm(curproc);
801039a5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039a8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039aa:	53                   	push   %ebx
801039ab:	e8 60 2f 00 00       	call   80106910 <switchuvm>
  return 0;
801039b0:	83 c4 10             	add    $0x10,%esp
801039b3:	31 c0                	xor    %eax,%eax
}
801039b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039b8:	5b                   	pop    %ebx
801039b9:	5e                   	pop    %esi
801039ba:	5d                   	pop    %ebp
801039bb:	c3                   	ret    
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039c0:	83 ec 04             	sub    $0x4,%esp
801039c3:	01 c6                	add    %eax,%esi
801039c5:	56                   	push   %esi
801039c6:	50                   	push   %eax
801039c7:	ff 73 04             	pushl  0x4(%ebx)
801039ca:	e8 91 31 00 00       	call   80106b60 <allocuvm>
801039cf:	83 c4 10             	add    $0x10,%esp
801039d2:	85 c0                	test   %eax,%eax
801039d4:	75 cf                	jne    801039a5 <growproc+0x25>
      return -1;
801039d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039db:	eb d8                	jmp    801039b5 <growproc+0x35>
801039dd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039e0:	83 ec 04             	sub    $0x4,%esp
801039e3:	01 c6                	add    %eax,%esi
801039e5:	56                   	push   %esi
801039e6:	50                   	push   %eax
801039e7:	ff 73 04             	pushl  0x4(%ebx)
801039ea:	e8 a1 32 00 00       	call   80106c90 <deallocuvm>
801039ef:	83 c4 10             	add    $0x10,%esp
801039f2:	85 c0                	test   %eax,%eax
801039f4:	75 af                	jne    801039a5 <growproc+0x25>
801039f6:	eb de                	jmp    801039d6 <growproc+0x56>
801039f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ff:	90                   	nop

80103a00 <fork>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a09:	e8 22 0a 00 00       	call   80104430 <pushcli>
  c = mycpu();
80103a0e:	e8 bd fd ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103a13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a19:	e8 22 0b 00 00       	call   80104540 <popcli>
  if((np = allocproc()) == 0){
80103a1e:	e8 6d fc ff ff       	call   80103690 <allocproc>
80103a23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a26:	85 c0                	test   %eax,%eax
80103a28:	0f 84 b7 00 00 00    	je     80103ae5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a2e:	83 ec 08             	sub    $0x8,%esp
80103a31:	ff 33                	pushl  (%ebx)
80103a33:	89 c7                	mov    %eax,%edi
80103a35:	ff 73 04             	pushl  0x4(%ebx)
80103a38:	e8 d3 33 00 00       	call   80106e10 <copyuvm>
80103a3d:	83 c4 10             	add    $0x10,%esp
80103a40:	89 47 04             	mov    %eax,0x4(%edi)
80103a43:	85 c0                	test   %eax,%eax
80103a45:	0f 84 a1 00 00 00    	je     80103aec <fork+0xec>
  np->sz = curproc->sz;
80103a4b:	8b 03                	mov    (%ebx),%eax
80103a4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a50:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103a52:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103a55:	89 c8                	mov    %ecx,%eax
80103a57:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103a5a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a5f:	8b 73 18             	mov    0x18(%ebx),%esi
80103a62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a66:	8b 40 18             	mov    0x18(%eax),%eax
80103a69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a74:	85 c0                	test   %eax,%eax
80103a76:	74 13                	je     80103a8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a78:	83 ec 0c             	sub    $0xc,%esp
80103a7b:	50                   	push   %eax
80103a7c:	e8 df d3 ff ff       	call   80100e60 <filedup>
80103a81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a84:	83 c4 10             	add    $0x10,%esp
80103a87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a8b:	83 c6 01             	add    $0x1,%esi
80103a8e:	83 fe 10             	cmp    $0x10,%esi
80103a91:	75 dd                	jne    80103a70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a93:	83 ec 0c             	sub    $0xc,%esp
80103a96:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103a9c:	e8 3f dc ff ff       	call   801016e0 <idup>
80103aa1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aa4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103aa7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aaa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103aad:	6a 10                	push   $0x10
80103aaf:	53                   	push   %ebx
80103ab0:	50                   	push   %eax
80103ab1:	e8 fa 0c 00 00       	call   801047b0 <safestrcpy>
  pid = np->pid;
80103ab6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ab9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ac0:	e8 bb 09 00 00       	call   80104480 <acquire>
  np->state = RUNNABLE;
80103ac5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103acc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ad3:	e8 c8 0a 00 00       	call   801045a0 <release>
  return pid;
80103ad8:	83 c4 10             	add    $0x10,%esp
}
80103adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ade:	89 d8                	mov    %ebx,%eax
80103ae0:	5b                   	pop    %ebx
80103ae1:	5e                   	pop    %esi
80103ae2:	5f                   	pop    %edi
80103ae3:	5d                   	pop    %ebp
80103ae4:	c3                   	ret    
    return -1;
80103ae5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103aea:	eb ef                	jmp    80103adb <fork+0xdb>
    kfree(np->kstack);
80103aec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103aef:	83 ec 0c             	sub    $0xc,%esp
80103af2:	ff 73 08             	pushl  0x8(%ebx)
80103af5:	e8 d6 e8 ff ff       	call   801023d0 <kfree>
    np->kstack = 0;
80103afa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103b01:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103b04:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b10:	eb c9                	jmp    80103adb <fork+0xdb>
80103b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b20 <scheduler>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b29:	e8 a2 fc ff ff       	call   801037d0 <mycpu>
  c->proc = 0;
80103b2e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b35:	00 00 00 
  struct cpu *c = mycpu();
80103b38:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b3a:	8d 78 04             	lea    0x4(%eax),%edi
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103b40:	fb                   	sti    
    acquire(&ptable.lock);
80103b41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b44:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103b49:	68 20 2d 11 80       	push   $0x80112d20
80103b4e:	e8 2d 09 00 00       	call   80104480 <acquire>
80103b53:	83 c4 10             	add    $0x10,%esp
80103b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103b60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b64:	75 33                	jne    80103b99 <scheduler+0x79>
      switchuvm(p);
80103b66:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b6f:	53                   	push   %ebx
80103b70:	e8 9b 2d 00 00       	call   80106910 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103b75:	58                   	pop    %eax
80103b76:	5a                   	pop    %edx
80103b77:	ff 73 1c             	pushl  0x1c(%ebx)
80103b7a:	57                   	push   %edi
      p->state = RUNNING;
80103b7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103b82:	e8 84 0c 00 00       	call   8010480b <swtch>
      switchkvm();
80103b87:	e8 74 2d 00 00       	call   80106900 <switchkvm>
      c->proc = 0;
80103b8c:	83 c4 10             	add    $0x10,%esp
80103b8f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b96:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b99:	83 c3 7c             	add    $0x7c,%ebx
80103b9c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ba2:	75 bc                	jne    80103b60 <scheduler+0x40>
    release(&ptable.lock);
80103ba4:	83 ec 0c             	sub    $0xc,%esp
80103ba7:	68 20 2d 11 80       	push   $0x80112d20
80103bac:	e8 ef 09 00 00       	call   801045a0 <release>
    sti();
80103bb1:	83 c4 10             	add    $0x10,%esp
80103bb4:	eb 8a                	jmp    80103b40 <scheduler+0x20>
80103bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi

80103bc0 <sched>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
  pushcli();
80103bc5:	e8 66 08 00 00       	call   80104430 <pushcli>
  c = mycpu();
80103bca:	e8 01 fc ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103bcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd5:	e8 66 09 00 00       	call   80104540 <popcli>
  if(!holding(&ptable.lock))
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	68 20 2d 11 80       	push   $0x80112d20
80103be2:	e8 09 08 00 00       	call   801043f0 <holding>
80103be7:	83 c4 10             	add    $0x10,%esp
80103bea:	85 c0                	test   %eax,%eax
80103bec:	74 4f                	je     80103c3d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103bee:	e8 dd fb ff ff       	call   801037d0 <mycpu>
80103bf3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bfa:	75 68                	jne    80103c64 <sched+0xa4>
  if(p->state == RUNNING)
80103bfc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c00:	74 55                	je     80103c57 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c02:	9c                   	pushf  
80103c03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c04:	f6 c4 02             	test   $0x2,%ah
80103c07:	75 41                	jne    80103c4a <sched+0x8a>
  intena = mycpu()->intena;
80103c09:	e8 c2 fb ff ff       	call   801037d0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c0e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c17:	e8 b4 fb ff ff       	call   801037d0 <mycpu>
80103c1c:	83 ec 08             	sub    $0x8,%esp
80103c1f:	ff 70 04             	pushl  0x4(%eax)
80103c22:	53                   	push   %ebx
80103c23:	e8 e3 0b 00 00       	call   8010480b <swtch>
  mycpu()->intena = intena;
80103c28:	e8 a3 fb ff ff       	call   801037d0 <mycpu>
}
80103c2d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c39:	5b                   	pop    %ebx
80103c3a:	5e                   	pop    %esi
80103c3b:	5d                   	pop    %ebp
80103c3c:	c3                   	ret    
    panic("sched ptable.lock");
80103c3d:	83 ec 0c             	sub    $0xc,%esp
80103c40:	68 3b 75 10 80       	push   $0x8010753b
80103c45:	e8 36 c7 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103c4a:	83 ec 0c             	sub    $0xc,%esp
80103c4d:	68 67 75 10 80       	push   $0x80107567
80103c52:	e8 29 c7 ff ff       	call   80100380 <panic>
    panic("sched running");
80103c57:	83 ec 0c             	sub    $0xc,%esp
80103c5a:	68 59 75 10 80       	push   $0x80107559
80103c5f:	e8 1c c7 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	68 4d 75 10 80       	push   $0x8010754d
80103c6c:	e8 0f c7 ff ff       	call   80100380 <panic>
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop

80103c80 <exit>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c89:	e8 a2 07 00 00       	call   80104430 <pushcli>
  c = mycpu();
80103c8e:	e8 3d fb ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103c93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c99:	e8 a2 08 00 00       	call   80104540 <popcli>
  if(curproc == initproc)
80103c9e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ca1:	8d 7e 68             	lea    0x68(%esi),%edi
80103ca4:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103caa:	0f 84 e7 00 00 00    	je     80103d97 <exit+0x117>
    if(curproc->ofile[fd]){
80103cb0:	8b 03                	mov    (%ebx),%eax
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	74 12                	je     80103cc8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103cb6:	83 ec 0c             	sub    $0xc,%esp
80103cb9:	50                   	push   %eax
80103cba:	e8 f1 d1 ff ff       	call   80100eb0 <fileclose>
      curproc->ofile[fd] = 0;
80103cbf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103cc5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103cc8:	83 c3 04             	add    $0x4,%ebx
80103ccb:	39 df                	cmp    %ebx,%edi
80103ccd:	75 e1                	jne    80103cb0 <exit+0x30>
  begin_op();
80103ccf:	e8 9c ef ff ff       	call   80102c70 <begin_op>
  iput(curproc->cwd);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	ff 76 68             	pushl  0x68(%esi)
80103cda:	e8 61 db ff ff       	call   80101840 <iput>
  end_op();
80103cdf:	e8 fc ef ff ff       	call   80102ce0 <end_op>
  curproc->cwd = 0;
80103ce4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103ceb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf2:	e8 89 07 00 00       	call   80104480 <acquire>
  wakeup1(curproc->parent);
80103cf7:	8b 56 14             	mov    0x14(%esi),%edx
80103cfa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cfd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d02:	eb 0e                	jmp    80103d12 <exit+0x92>
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d08:	83 c0 7c             	add    $0x7c,%eax
80103d0b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d10:	74 1c                	je     80103d2e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d12:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d16:	75 f0                	jne    80103d08 <exit+0x88>
80103d18:	3b 50 20             	cmp    0x20(%eax),%edx
80103d1b:	75 eb                	jne    80103d08 <exit+0x88>
      p->state = RUNNABLE;
80103d1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d24:	83 c0 7c             	add    $0x7c,%eax
80103d27:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d2c:	75 e4                	jne    80103d12 <exit+0x92>
      p->parent = initproc;
80103d2e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d34:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d39:	eb 10                	jmp    80103d4b <exit+0xcb>
80103d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop
80103d40:	83 c2 7c             	add    $0x7c,%edx
80103d43:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103d49:	74 33                	je     80103d7e <exit+0xfe>
    if(p->parent == curproc){
80103d4b:	39 72 14             	cmp    %esi,0x14(%edx)
80103d4e:	75 f0                	jne    80103d40 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d50:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d54:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d57:	75 e7                	jne    80103d40 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d59:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d5e:	eb 0a                	jmp    80103d6a <exit+0xea>
80103d60:	83 c0 7c             	add    $0x7c,%eax
80103d63:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d68:	74 d6                	je     80103d40 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d6e:	75 f0                	jne    80103d60 <exit+0xe0>
80103d70:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d73:	75 eb                	jne    80103d60 <exit+0xe0>
      p->state = RUNNABLE;
80103d75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d7c:	eb e2                	jmp    80103d60 <exit+0xe0>
  curproc->state = ZOMBIE;
80103d7e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d85:	e8 36 fe ff ff       	call   80103bc0 <sched>
  panic("zombie exit");
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	68 88 75 10 80       	push   $0x80107588
80103d92:	e8 e9 c5 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	68 7b 75 10 80       	push   $0x8010757b
80103d9f:	e8 dc c5 ff ff       	call   80100380 <panic>
80103da4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <yield>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
80103db4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103db7:	68 20 2d 11 80       	push   $0x80112d20
80103dbc:	e8 bf 06 00 00       	call   80104480 <acquire>
  pushcli();
80103dc1:	e8 6a 06 00 00       	call   80104430 <pushcli>
  c = mycpu();
80103dc6:	e8 05 fa ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103dcb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd1:	e8 6a 07 00 00       	call   80104540 <popcli>
  myproc()->state = RUNNABLE;
80103dd6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ddd:	e8 de fd ff ff       	call   80103bc0 <sched>
  release(&ptable.lock);
80103de2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103de9:	e8 b2 07 00 00       	call   801045a0 <release>
}
80103dee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103df1:	83 c4 10             	add    $0x10,%esp
80103df4:	c9                   	leave  
80103df5:	c3                   	ret    
80103df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi

80103e00 <sleep>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 0c             	sub    $0xc,%esp
80103e09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e0f:	e8 1c 06 00 00       	call   80104430 <pushcli>
  c = mycpu();
80103e14:	e8 b7 f9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103e19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e1f:	e8 1c 07 00 00       	call   80104540 <popcli>
  if(p == 0)
80103e24:	85 db                	test   %ebx,%ebx
80103e26:	0f 84 87 00 00 00    	je     80103eb3 <sleep+0xb3>
  if(lk == 0)
80103e2c:	85 f6                	test   %esi,%esi
80103e2e:	74 76                	je     80103ea6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e30:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e36:	74 50                	je     80103e88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e38:	83 ec 0c             	sub    $0xc,%esp
80103e3b:	68 20 2d 11 80       	push   $0x80112d20
80103e40:	e8 3b 06 00 00       	call   80104480 <acquire>
    release(lk);
80103e45:	89 34 24             	mov    %esi,(%esp)
80103e48:	e8 53 07 00 00       	call   801045a0 <release>
  p->chan = chan;
80103e4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e57:	e8 64 fd ff ff       	call   80103bc0 <sched>
  p->chan = 0;
80103e5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e63:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e6a:	e8 31 07 00 00       	call   801045a0 <release>
    acquire(lk);
80103e6f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e72:	83 c4 10             	add    $0x10,%esp
}
80103e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e78:	5b                   	pop    %ebx
80103e79:	5e                   	pop    %esi
80103e7a:	5f                   	pop    %edi
80103e7b:	5d                   	pop    %ebp
    acquire(lk);
80103e7c:	e9 ff 05 00 00       	jmp    80104480 <acquire>
80103e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e92:	e8 29 fd ff ff       	call   80103bc0 <sched>
  p->chan = 0;
80103e97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea1:	5b                   	pop    %ebx
80103ea2:	5e                   	pop    %esi
80103ea3:	5f                   	pop    %edi
80103ea4:	5d                   	pop    %ebp
80103ea5:	c3                   	ret    
    panic("sleep without lk");
80103ea6:	83 ec 0c             	sub    $0xc,%esp
80103ea9:	68 9a 75 10 80       	push   $0x8010759a
80103eae:	e8 cd c4 ff ff       	call   80100380 <panic>
    panic("sleep");
80103eb3:	83 ec 0c             	sub    $0xc,%esp
80103eb6:	68 94 75 10 80       	push   $0x80107594
80103ebb:	e8 c0 c4 ff ff       	call   80100380 <panic>

80103ec0 <wait>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  pushcli();
80103ec5:	e8 66 05 00 00       	call   80104430 <pushcli>
  c = mycpu();
80103eca:	e8 01 f9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103ecf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ed5:	e8 66 06 00 00       	call   80104540 <popcli>
  acquire(&ptable.lock);
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 20 2d 11 80       	push   $0x80112d20
80103ee2:	e8 99 05 00 00       	call   80104480 <acquire>
80103ee7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ef1:	eb 10                	jmp    80103f03 <wait+0x43>
80103ef3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef7:	90                   	nop
80103ef8:	83 c3 7c             	add    $0x7c,%ebx
80103efb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f01:	74 1b                	je     80103f1e <wait+0x5e>
      if(p->parent != curproc)
80103f03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f06:	75 f0                	jne    80103ef8 <wait+0x38>
      if(p->state == ZOMBIE){
80103f08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f0c:	74 32                	je     80103f40 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f11:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f16:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f1c:	75 e5                	jne    80103f03 <wait+0x43>
    if(!havekids || curproc->killed){
80103f1e:	85 c0                	test   %eax,%eax
80103f20:	74 74                	je     80103f96 <wait+0xd6>
80103f22:	8b 46 24             	mov    0x24(%esi),%eax
80103f25:	85 c0                	test   %eax,%eax
80103f27:	75 6d                	jne    80103f96 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f29:	83 ec 08             	sub    $0x8,%esp
80103f2c:	68 20 2d 11 80       	push   $0x80112d20
80103f31:	56                   	push   %esi
80103f32:	e8 c9 fe ff ff       	call   80103e00 <sleep>
    havekids = 0;
80103f37:	83 c4 10             	add    $0x10,%esp
80103f3a:	eb ae                	jmp    80103eea <wait+0x2a>
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f46:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f49:	e8 82 e4 ff ff       	call   801023d0 <kfree>
        freevm(p->pgdir);
80103f4e:	5a                   	pop    %edx
80103f4f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f59:	e8 62 2d 00 00       	call   80106cc0 <freevm>
        release(&ptable.lock);
80103f5e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103f65:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f6c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f73:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f77:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f7e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f85:	e8 16 06 00 00       	call   801045a0 <release>
        return pid;
80103f8a:	83 c4 10             	add    $0x10,%esp
}
80103f8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f90:	89 f0                	mov    %esi,%eax
80103f92:	5b                   	pop    %ebx
80103f93:	5e                   	pop    %esi
80103f94:	5d                   	pop    %ebp
80103f95:	c3                   	ret    
      release(&ptable.lock);
80103f96:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f99:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f9e:	68 20 2d 11 80       	push   $0x80112d20
80103fa3:	e8 f8 05 00 00       	call   801045a0 <release>
      return -1;
80103fa8:	83 c4 10             	add    $0x10,%esp
80103fab:	eb e0                	jmp    80103f8d <wait+0xcd>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi

80103fb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	53                   	push   %ebx
80103fb4:	83 ec 10             	sub    $0x10,%esp
80103fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103fba:	68 20 2d 11 80       	push   $0x80112d20
80103fbf:	e8 bc 04 00 00       	call   80104480 <acquire>
80103fc4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fc7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fcc:	eb 0c                	jmp    80103fda <wakeup+0x2a>
80103fce:	66 90                	xchg   %ax,%ax
80103fd0:	83 c0 7c             	add    $0x7c,%eax
80103fd3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103fd8:	74 1c                	je     80103ff6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103fda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fde:	75 f0                	jne    80103fd0 <wakeup+0x20>
80103fe0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fe3:	75 eb                	jne    80103fd0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fe5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fec:	83 c0 7c             	add    $0x7c,%eax
80103fef:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ff4:	75 e4                	jne    80103fda <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103ff6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103ffd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104000:	c9                   	leave  
  release(&ptable.lock);
80104001:	e9 9a 05 00 00       	jmp    801045a0 <release>
80104006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400d:	8d 76 00             	lea    0x0(%esi),%esi

80104010 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 10             	sub    $0x10,%esp
80104017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010401a:	68 20 2d 11 80       	push   $0x80112d20
8010401f:	e8 5c 04 00 00       	call   80104480 <acquire>
80104024:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104027:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010402c:	eb 0c                	jmp    8010403a <kill+0x2a>
8010402e:	66 90                	xchg   %ax,%ax
80104030:	83 c0 7c             	add    $0x7c,%eax
80104033:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104038:	74 36                	je     80104070 <kill+0x60>
    if(p->pid == pid){
8010403a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010403d:	75 f1                	jne    80104030 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010403f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104043:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010404a:	75 07                	jne    80104053 <kill+0x43>
        p->state = RUNNABLE;
8010404c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104053:	83 ec 0c             	sub    $0xc,%esp
80104056:	68 20 2d 11 80       	push   $0x80112d20
8010405b:	e8 40 05 00 00       	call   801045a0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104063:	83 c4 10             	add    $0x10,%esp
80104066:	31 c0                	xor    %eax,%eax
}
80104068:	c9                   	leave  
80104069:	c3                   	ret    
8010406a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104070:	83 ec 0c             	sub    $0xc,%esp
80104073:	68 20 2d 11 80       	push   $0x80112d20
80104078:	e8 23 05 00 00       	call   801045a0 <release>
}
8010407d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104080:	83 c4 10             	add    $0x10,%esp
80104083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104088:	c9                   	leave  
80104089:	c3                   	ret    
8010408a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104090 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104098:	53                   	push   %ebx
80104099:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010409e:	83 ec 3c             	sub    $0x3c,%esp
801040a1:	eb 24                	jmp    801040c7 <procdump+0x37>
801040a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 cb 75 10 80       	push   $0x801075cb
801040b0:	e8 eb c5 ff ff       	call   801006a0 <cprintf>
801040b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b8:	83 c3 7c             	add    $0x7c,%ebx
801040bb:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
801040c1:	0f 84 81 00 00 00    	je     80104148 <procdump+0xb8>
    if(p->state == UNUSED)
801040c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040ca:	85 c0                	test   %eax,%eax
801040cc:	74 ea                	je     801040b8 <procdump+0x28>
      state = "???";
801040ce:	ba ab 75 10 80       	mov    $0x801075ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d3:	83 f8 05             	cmp    $0x5,%eax
801040d6:	77 11                	ja     801040e9 <procdump+0x59>
801040d8:	8b 14 85 64 76 10 80 	mov    -0x7fef899c(,%eax,4),%edx
      state = "???";
801040df:	b8 ab 75 10 80       	mov    $0x801075ab,%eax
801040e4:	85 d2                	test   %edx,%edx
801040e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040e9:	53                   	push   %ebx
801040ea:	52                   	push   %edx
801040eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801040ee:	68 af 75 10 80       	push   $0x801075af
801040f3:	e8 a8 c5 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801040f8:	83 c4 10             	add    $0x10,%esp
801040fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801040ff:	75 a7                	jne    801040a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104101:	83 ec 08             	sub    $0x8,%esp
80104104:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104107:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010410a:	50                   	push   %eax
8010410b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010410e:	8b 40 0c             	mov    0xc(%eax),%eax
80104111:	83 c0 08             	add    $0x8,%eax
80104114:	50                   	push   %eax
80104115:	e8 86 02 00 00       	call   801043a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010411a:	83 c4 10             	add    $0x10,%esp
8010411d:	8d 76 00             	lea    0x0(%esi),%esi
80104120:	8b 17                	mov    (%edi),%edx
80104122:	85 d2                	test   %edx,%edx
80104124:	74 82                	je     801040a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104126:	83 ec 08             	sub    $0x8,%esp
80104129:	83 c7 04             	add    $0x4,%edi
8010412c:	52                   	push   %edx
8010412d:	68 01 70 10 80       	push   $0x80107001
80104132:	e8 69 c5 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104137:	83 c4 10             	add    $0x10,%esp
8010413a:	39 fe                	cmp    %edi,%esi
8010413c:	75 e2                	jne    80104120 <procdump+0x90>
8010413e:	e9 65 ff ff ff       	jmp    801040a8 <procdump+0x18>
80104143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104147:	90                   	nop
  }
}
80104148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010414b:	5b                   	pop    %ebx
8010414c:	5e                   	pop    %esi
8010414d:	5f                   	pop    %edi
8010414e:	5d                   	pop    %ebp
8010414f:	c3                   	ret    

80104150 <cps>:

int
cps()
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	83 ec 18             	sub    $0x18,%esp
  asm volatile("sti");
80104159:	fb                   	sti    
 int run_count = 0; 
 int sleep_count = 0; 
 // Enable interrupts on this processor.
 sti();
 // Loop over process table looking for process with pid.
 acquire(&ptable.lock);
8010415a:	68 20 2d 11 80       	push   $0x80112d20
 int sleep_count = 0; 
8010415f:	31 f6                	xor    %esi,%esi
 int run_count = 0; 
80104161:	31 ff                	xor    %edi,%edi
 cprintf("name \t pid \t state \n");
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104163:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
 acquire(&ptable.lock);
80104168:	e8 13 03 00 00       	call   80104480 <acquire>
 cprintf("name \t pid \t state \n");
8010416d:	c7 04 24 b8 75 10 80 	movl   $0x801075b8,(%esp)
80104174:	e8 27 c5 ff ff       	call   801006a0 <cprintf>
80104179:	83 c4 10             	add    $0x10,%esp
8010417c:	eb 12                	jmp    80104190 <cps+0x40>
8010417e:	66 90                	xchg   %ax,%ax
 if ( p->state == SLEEPING ){
 cprintf("%s \t %d \t SLEEPING \n ", p->name, p->pid );
 sleep_count++; 
 }
 else if ( p->state == RUNNING ){
80104180:	83 f8 04             	cmp    $0x4,%eax
80104183:	74 53                	je     801041d8 <cps+0x88>
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104185:	83 c3 7c             	add    $0x7c,%ebx
80104188:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010418e:	74 2d                	je     801041bd <cps+0x6d>
 if ( p->state == SLEEPING ){
80104190:	8b 43 0c             	mov    0xc(%ebx),%eax
80104193:	83 f8 02             	cmp    $0x2,%eax
80104196:	75 e8                	jne    80104180 <cps+0x30>
 cprintf("%s \t %d \t SLEEPING \n ", p->name, p->pid );
80104198:	83 ec 04             	sub    $0x4,%esp
8010419b:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010419e:	ff 73 10             	pushl  0x10(%ebx)
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a1:	83 c3 7c             	add    $0x7c,%ebx
 cprintf("%s \t %d \t SLEEPING \n ", p->name, p->pid );
801041a4:	50                   	push   %eax
 sleep_count++; 
801041a5:	83 c6 01             	add    $0x1,%esi
 cprintf("%s \t %d \t SLEEPING \n ", p->name, p->pid );
801041a8:	68 cd 75 10 80       	push   $0x801075cd
801041ad:	e8 ee c4 ff ff       	call   801006a0 <cprintf>
 sleep_count++; 
801041b2:	83 c4 10             	add    $0x10,%esp
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b5:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801041bb:	75 d3                	jne    80104190 <cps+0x40>
 cprintf("%s \t %d \t RUNNING \n ", p->name, p->pid );
 run_count++; 
 }
 }
 
 release(&ptable.lock);
801041bd:	83 ec 0c             	sub    $0xc,%esp
801041c0:	68 20 2d 11 80       	push   $0x80112d20
801041c5:	e8 d6 03 00 00       	call   801045a0 <release>
 
 return (sleep_count+run_count);
}
801041ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 return (sleep_count+run_count);
801041cd:	8d 04 37             	lea    (%edi,%esi,1),%eax
}
801041d0:	5b                   	pop    %ebx
801041d1:	5e                   	pop    %esi
801041d2:	5f                   	pop    %edi
801041d3:	5d                   	pop    %ebp
801041d4:	c3                   	ret    
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
 cprintf("%s \t %d \t RUNNING \n ", p->name, p->pid );
801041d8:	83 ec 04             	sub    $0x4,%esp
801041db:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041de:	ff 73 10             	pushl  0x10(%ebx)
 run_count++; 
801041e1:	83 c7 01             	add    $0x1,%edi
 cprintf("%s \t %d \t RUNNING \n ", p->name, p->pid );
801041e4:	50                   	push   %eax
801041e5:	68 e3 75 10 80       	push   $0x801075e3
801041ea:	e8 b1 c4 ff ff       	call   801006a0 <cprintf>
 run_count++; 
801041ef:	83 c4 10             	add    $0x10,%esp
801041f2:	eb 91                	jmp    80104185 <cps+0x35>
801041f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041ff:	90                   	nop

80104200 <nps>:

int nps()
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	83 ec 14             	sub    $0x14,%esp
80104206:	fb                   	sti    

  // Enable interrupts on this processor.
  sti();

  // loop over process table.
  acquire(&ptable.lock);
80104207:	68 20 2d 11 80       	push   $0x80112d20
8010420c:	e8 6f 02 00 00       	call   80104480 <acquire>
80104211:	83 c4 10             	add    $0x10,%esp
  int count = 0;
80104214:	31 c9                	xor    %ecx,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104216:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010421b:	eb 1d                	jmp    8010423a <nps+0x3a>
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
  {
    if (p->state == SLEEPING)
      count++;
    else if (p->state == RUNNING)
80104220:	83 fa 04             	cmp    $0x4,%edx
80104223:	74 1d                	je     80104242 <nps+0x42>
      count++;
    else if (p->state == RUNNABLE)
      count++;
80104225:	83 fa 03             	cmp    $0x3,%edx
80104228:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010422b:	83 c0 7c             	add    $0x7c,%eax
      count++;
8010422e:	0f b6 d2             	movzbl %dl,%edx
80104231:	01 d1                	add    %edx,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104233:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104238:	74 15                	je     8010424f <nps+0x4f>
    if (p->state == SLEEPING)
8010423a:	8b 50 0c             	mov    0xc(%eax),%edx
8010423d:	83 fa 02             	cmp    $0x2,%edx
80104240:	75 de                	jne    80104220 <nps+0x20>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104242:	83 c0 7c             	add    $0x7c,%eax
      count++;
80104245:	83 c1 01             	add    $0x1,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104248:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
8010424d:	75 eb                	jne    8010423a <nps+0x3a>
  }
  cprintf("Number of processes: %d\n", count);
8010424f:	83 ec 08             	sub    $0x8,%esp
80104252:	51                   	push   %ecx
80104253:	68 f8 75 10 80       	push   $0x801075f8
80104258:	e8 43 c4 ff ff       	call   801006a0 <cprintf>
  release(&ptable.lock);
8010425d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104264:	e8 37 03 00 00       	call   801045a0 <release>

  return 23;
}
80104269:	b8 17 00 00 00       	mov    $0x17,%eax
8010426e:	c9                   	leave  
8010426f:	c3                   	ret    

80104270 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
80104274:	83 ec 0c             	sub    $0xc,%esp
80104277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010427a:	68 7c 76 10 80       	push   $0x8010767c
8010427f:	8d 43 04             	lea    0x4(%ebx),%eax
80104282:	50                   	push   %eax
80104283:	e8 f8 00 00 00       	call   80104380 <initlock>
  lk->name = name;
80104288:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010428b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104291:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104294:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010429b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010429e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042a1:	c9                   	leave  
801042a2:	c3                   	ret    
801042a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042b8:	8d 73 04             	lea    0x4(%ebx),%esi
801042bb:	83 ec 0c             	sub    $0xc,%esp
801042be:	56                   	push   %esi
801042bf:	e8 bc 01 00 00       	call   80104480 <acquire>
  while (lk->locked) {
801042c4:	8b 13                	mov    (%ebx),%edx
801042c6:	83 c4 10             	add    $0x10,%esp
801042c9:	85 d2                	test   %edx,%edx
801042cb:	74 16                	je     801042e3 <acquiresleep+0x33>
801042cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801042d0:	83 ec 08             	sub    $0x8,%esp
801042d3:	56                   	push   %esi
801042d4:	53                   	push   %ebx
801042d5:	e8 26 fb ff ff       	call   80103e00 <sleep>
  while (lk->locked) {
801042da:	8b 03                	mov    (%ebx),%eax
801042dc:	83 c4 10             	add    $0x10,%esp
801042df:	85 c0                	test   %eax,%eax
801042e1:	75 ed                	jne    801042d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801042e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801042e9:	e8 72 f5 ff ff       	call   80103860 <myproc>
801042ee:	8b 40 10             	mov    0x10(%eax),%eax
801042f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801042f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801042f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042fa:	5b                   	pop    %ebx
801042fb:	5e                   	pop    %esi
801042fc:	5d                   	pop    %ebp
  release(&lk->lk);
801042fd:	e9 9e 02 00 00       	jmp    801045a0 <release>
80104302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104310 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104318:	8d 73 04             	lea    0x4(%ebx),%esi
8010431b:	83 ec 0c             	sub    $0xc,%esp
8010431e:	56                   	push   %esi
8010431f:	e8 5c 01 00 00       	call   80104480 <acquire>
  lk->locked = 0;
80104324:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010432a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104331:	89 1c 24             	mov    %ebx,(%esp)
80104334:	e8 77 fc ff ff       	call   80103fb0 <wakeup>
  release(&lk->lk);
80104339:	89 75 08             	mov    %esi,0x8(%ebp)
8010433c:	83 c4 10             	add    $0x10,%esp
}
8010433f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104342:	5b                   	pop    %ebx
80104343:	5e                   	pop    %esi
80104344:	5d                   	pop    %ebp
  release(&lk->lk);
80104345:	e9 56 02 00 00       	jmp    801045a0 <release>
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104358:	8d 5e 04             	lea    0x4(%esi),%ebx
8010435b:	83 ec 0c             	sub    $0xc,%esp
8010435e:	53                   	push   %ebx
8010435f:	e8 1c 01 00 00       	call   80104480 <acquire>
  r = lk->locked;
80104364:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104366:	89 1c 24             	mov    %ebx,(%esp)
80104369:	e8 32 02 00 00       	call   801045a0 <release>
  return r;
}
8010436e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104371:	89 f0                	mov    %esi,%eax
80104373:	5b                   	pop    %ebx
80104374:	5e                   	pop    %esi
80104375:	5d                   	pop    %ebp
80104376:	c3                   	ret    
80104377:	66 90                	xchg   %ax,%ax
80104379:	66 90                	xchg   %ax,%ax
8010437b:	66 90                	xchg   %ax,%ax
8010437d:	66 90                	xchg   %ax,%ax
8010437f:	90                   	nop

80104380 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104386:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010438f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104392:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104399:	5d                   	pop    %ebp
8010439a:	c3                   	ret    
8010439b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop

801043a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043a1:	31 d2                	xor    %edx,%edx
{
801043a3:	89 e5                	mov    %esp,%ebp
801043a5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043a6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043ac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801043af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801043b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043bc:	77 1a                	ja     801043d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043be:	8b 58 04             	mov    0x4(%eax),%ebx
801043c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043c7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043c9:	83 fa 0a             	cmp    $0xa,%edx
801043cc:	75 e2                	jne    801043b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043ce:	5b                   	pop    %ebx
801043cf:	5d                   	pop    %ebp
801043d0:	c3                   	ret    
801043d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801043d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043db:	8d 51 28             	lea    0x28(%ecx),%edx
801043de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801043e6:	83 c0 04             	add    $0x4,%eax
801043e9:	39 d0                	cmp    %edx,%eax
801043eb:	75 f3                	jne    801043e0 <getcallerpcs+0x40>
}
801043ed:	5b                   	pop    %ebx
801043ee:	5d                   	pop    %ebp
801043ef:	c3                   	ret    

801043f0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 04             	sub    $0x4,%esp
801043f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801043fa:	8b 02                	mov    (%edx),%eax
801043fc:	85 c0                	test   %eax,%eax
801043fe:	75 10                	jne    80104410 <holding+0x20>
}
80104400:	83 c4 04             	add    $0x4,%esp
80104403:	31 c0                	xor    %eax,%eax
80104405:	5b                   	pop    %ebx
80104406:	5d                   	pop    %ebp
80104407:	c3                   	ret    
80104408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104410:	8b 5a 08             	mov    0x8(%edx),%ebx
80104413:	e8 b8 f3 ff ff       	call   801037d0 <mycpu>
80104418:	39 c3                	cmp    %eax,%ebx
8010441a:	0f 94 c0             	sete   %al
}
8010441d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104420:	0f b6 c0             	movzbl %al,%eax
}
80104423:	5b                   	pop    %ebx
80104424:	5d                   	pop    %ebp
80104425:	c3                   	ret    
80104426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442d:	8d 76 00             	lea    0x0(%esi),%esi

80104430 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104437:	9c                   	pushf  
80104438:	5b                   	pop    %ebx
  asm volatile("cli");
80104439:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010443a:	e8 91 f3 ff ff       	call   801037d0 <mycpu>
8010443f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104445:	85 c0                	test   %eax,%eax
80104447:	74 17                	je     80104460 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104449:	e8 82 f3 ff ff       	call   801037d0 <mycpu>
8010444e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104455:	83 c4 04             	add    $0x4,%esp
80104458:	5b                   	pop    %ebx
80104459:	5d                   	pop    %ebp
8010445a:	c3                   	ret    
8010445b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104460:	e8 6b f3 ff ff       	call   801037d0 <mycpu>
80104465:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010446b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104471:	eb d6                	jmp    80104449 <pushcli+0x19>
80104473:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <acquire>:
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104485:	e8 a6 ff ff ff       	call   80104430 <pushcli>
  if(holding(lk))
8010448a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010448d:	8b 03                	mov    (%ebx),%eax
8010448f:	85 c0                	test   %eax,%eax
80104491:	0f 85 81 00 00 00    	jne    80104518 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104497:	ba 01 00 00 00       	mov    $0x1,%edx
8010449c:	eb 05                	jmp    801044a3 <acquire+0x23>
8010449e:	66 90                	xchg   %ax,%ax
801044a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044a3:	89 d0                	mov    %edx,%eax
801044a5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801044a8:	85 c0                	test   %eax,%eax
801044aa:	75 f4                	jne    801044a0 <acquire+0x20>
  __sync_synchronize();
801044ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801044b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044b4:	e8 17 f3 ff ff       	call   801037d0 <mycpu>
  ebp = (uint*)v - 2;
801044b9:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801044bb:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801044be:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044c0:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
801044c6:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801044cc:	77 22                	ja     801044f0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801044ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801044d1:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
801044d5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801044d8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801044da:	83 f8 0a             	cmp    $0xa,%eax
801044dd:	75 e1                	jne    801044c0 <acquire+0x40>
}
801044df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044e2:	5b                   	pop    %ebx
801044e3:	5e                   	pop    %esi
801044e4:	5d                   	pop    %ebp
801044e5:	c3                   	ret    
801044e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801044f0:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
801044f4:	83 c3 34             	add    $0x34,%ebx
801044f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104500:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104506:	83 c0 04             	add    $0x4,%eax
80104509:	39 d8                	cmp    %ebx,%eax
8010450b:	75 f3                	jne    80104500 <acquire+0x80>
}
8010450d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104510:	5b                   	pop    %ebx
80104511:	5e                   	pop    %esi
80104512:	5d                   	pop    %ebp
80104513:	c3                   	ret    
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104518:	8b 73 08             	mov    0x8(%ebx),%esi
8010451b:	e8 b0 f2 ff ff       	call   801037d0 <mycpu>
80104520:	39 c6                	cmp    %eax,%esi
80104522:	0f 85 6f ff ff ff    	jne    80104497 <acquire+0x17>
    panic("acquire");
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	68 87 76 10 80       	push   $0x80107687
80104530:	e8 4b be ff ff       	call   80100380 <panic>
80104535:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <popcli>:

void
popcli(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104546:	9c                   	pushf  
80104547:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104548:	f6 c4 02             	test   $0x2,%ah
8010454b:	75 35                	jne    80104582 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010454d:	e8 7e f2 ff ff       	call   801037d0 <mycpu>
80104552:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104559:	78 34                	js     8010458f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010455b:	e8 70 f2 ff ff       	call   801037d0 <mycpu>
80104560:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104566:	85 d2                	test   %edx,%edx
80104568:	74 06                	je     80104570 <popcli+0x30>
    sti();
}
8010456a:	c9                   	leave  
8010456b:	c3                   	ret    
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104570:	e8 5b f2 ff ff       	call   801037d0 <mycpu>
80104575:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010457b:	85 c0                	test   %eax,%eax
8010457d:	74 eb                	je     8010456a <popcli+0x2a>
  asm volatile("sti");
8010457f:	fb                   	sti    
}
80104580:	c9                   	leave  
80104581:	c3                   	ret    
    panic("popcli - interruptible");
80104582:	83 ec 0c             	sub    $0xc,%esp
80104585:	68 8f 76 10 80       	push   $0x8010768f
8010458a:	e8 f1 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010458f:	83 ec 0c             	sub    $0xc,%esp
80104592:	68 a6 76 10 80       	push   $0x801076a6
80104597:	e8 e4 bd ff ff       	call   80100380 <panic>
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <release>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801045a8:	8b 03                	mov    (%ebx),%eax
801045aa:	85 c0                	test   %eax,%eax
801045ac:	75 12                	jne    801045c0 <release+0x20>
    panic("release");
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	68 ad 76 10 80       	push   $0x801076ad
801045b6:	e8 c5 bd ff ff       	call   80100380 <panic>
801045bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
801045c0:	8b 73 08             	mov    0x8(%ebx),%esi
801045c3:	e8 08 f2 ff ff       	call   801037d0 <mycpu>
801045c8:	39 c6                	cmp    %eax,%esi
801045ca:	75 e2                	jne    801045ae <release+0xe>
  lk->pcs[0] = 0;
801045cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045d3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045da:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045e8:	5b                   	pop    %ebx
801045e9:	5e                   	pop    %esi
801045ea:	5d                   	pop    %ebp
  popcli();
801045eb:	e9 50 ff ff ff       	jmp    80104540 <popcli>

801045f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	8b 55 08             	mov    0x8(%ebp),%edx
801045f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045fa:	53                   	push   %ebx
801045fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801045fe:	89 d7                	mov    %edx,%edi
80104600:	09 cf                	or     %ecx,%edi
80104602:	83 e7 03             	and    $0x3,%edi
80104605:	75 29                	jne    80104630 <memset+0x40>
    c &= 0xFF;
80104607:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010460a:	c1 e0 18             	shl    $0x18,%eax
8010460d:	89 fb                	mov    %edi,%ebx
8010460f:	c1 e9 02             	shr    $0x2,%ecx
80104612:	c1 e3 10             	shl    $0x10,%ebx
80104615:	09 d8                	or     %ebx,%eax
80104617:	09 f8                	or     %edi,%eax
80104619:	c1 e7 08             	shl    $0x8,%edi
8010461c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010461e:	89 d7                	mov    %edx,%edi
80104620:	fc                   	cld    
80104621:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104623:	5b                   	pop    %ebx
80104624:	89 d0                	mov    %edx,%eax
80104626:	5f                   	pop    %edi
80104627:	5d                   	pop    %ebp
80104628:	c3                   	ret    
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104630:	89 d7                	mov    %edx,%edi
80104632:	fc                   	cld    
80104633:	f3 aa                	rep stos %al,%es:(%edi)
80104635:	5b                   	pop    %ebx
80104636:	89 d0                	mov    %edx,%eax
80104638:	5f                   	pop    %edi
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    
8010463b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010463f:	90                   	nop

80104640 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	8b 75 10             	mov    0x10(%ebp),%esi
80104647:	8b 55 08             	mov    0x8(%ebp),%edx
8010464a:	53                   	push   %ebx
8010464b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010464e:	85 f6                	test   %esi,%esi
80104650:	74 2e                	je     80104680 <memcmp+0x40>
80104652:	01 c6                	add    %eax,%esi
80104654:	eb 14                	jmp    8010466a <memcmp+0x2a>
80104656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104660:	83 c0 01             	add    $0x1,%eax
80104663:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104666:	39 f0                	cmp    %esi,%eax
80104668:	74 16                	je     80104680 <memcmp+0x40>
    if(*s1 != *s2)
8010466a:	0f b6 0a             	movzbl (%edx),%ecx
8010466d:	0f b6 18             	movzbl (%eax),%ebx
80104670:	38 d9                	cmp    %bl,%cl
80104672:	74 ec                	je     80104660 <memcmp+0x20>
      return *s1 - *s2;
80104674:	0f b6 c1             	movzbl %cl,%eax
80104677:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104679:	5b                   	pop    %ebx
8010467a:	5e                   	pop    %esi
8010467b:	5d                   	pop    %ebp
8010467c:	c3                   	ret    
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
80104680:	5b                   	pop    %ebx
  return 0;
80104681:	31 c0                	xor    %eax,%eax
}
80104683:	5e                   	pop    %esi
80104684:	5d                   	pop    %ebp
80104685:	c3                   	ret    
80104686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468d:	8d 76 00             	lea    0x0(%esi),%esi

80104690 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	8b 55 08             	mov    0x8(%ebp),%edx
80104697:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469a:	56                   	push   %esi
8010469b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010469e:	39 d6                	cmp    %edx,%esi
801046a0:	73 26                	jae    801046c8 <memmove+0x38>
801046a2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801046a5:	39 fa                	cmp    %edi,%edx
801046a7:	73 1f                	jae    801046c8 <memmove+0x38>
801046a9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801046ac:	85 c9                	test   %ecx,%ecx
801046ae:	74 0f                	je     801046bf <memmove+0x2f>
      *--d = *--s;
801046b0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801046b4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801046b7:	83 e8 01             	sub    $0x1,%eax
801046ba:	83 f8 ff             	cmp    $0xffffffff,%eax
801046bd:	75 f1                	jne    801046b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046bf:	5e                   	pop    %esi
801046c0:	89 d0                	mov    %edx,%eax
801046c2:	5f                   	pop    %edi
801046c3:	5d                   	pop    %ebp
801046c4:	c3                   	ret    
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801046c8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801046cb:	89 d7                	mov    %edx,%edi
801046cd:	85 c9                	test   %ecx,%ecx
801046cf:	74 ee                	je     801046bf <memmove+0x2f>
801046d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801046d8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801046d9:	39 f0                	cmp    %esi,%eax
801046db:	75 fb                	jne    801046d8 <memmove+0x48>
}
801046dd:	5e                   	pop    %esi
801046de:	89 d0                	mov    %edx,%eax
801046e0:	5f                   	pop    %edi
801046e1:	5d                   	pop    %ebp
801046e2:	c3                   	ret    
801046e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801046f0:	eb 9e                	jmp    80104690 <memmove>
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	8b 75 10             	mov    0x10(%ebp),%esi
80104707:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010470a:	53                   	push   %ebx
8010470b:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
8010470e:	85 f6                	test   %esi,%esi
80104710:	74 36                	je     80104748 <strncmp+0x48>
80104712:	01 c6                	add    %eax,%esi
80104714:	eb 18                	jmp    8010472e <strncmp+0x2e>
80104716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	38 da                	cmp    %bl,%dl
80104722:	75 14                	jne    80104738 <strncmp+0x38>
    n--, p++, q++;
80104724:	83 c0 01             	add    $0x1,%eax
80104727:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010472a:	39 f0                	cmp    %esi,%eax
8010472c:	74 1a                	je     80104748 <strncmp+0x48>
8010472e:	0f b6 11             	movzbl (%ecx),%edx
80104731:	0f b6 18             	movzbl (%eax),%ebx
80104734:	84 d2                	test   %dl,%dl
80104736:	75 e8                	jne    80104720 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104738:	0f b6 c2             	movzbl %dl,%eax
8010473b:	29 d8                	sub    %ebx,%eax
}
8010473d:	5b                   	pop    %ebx
8010473e:	5e                   	pop    %esi
8010473f:	5d                   	pop    %ebp
80104740:	c3                   	ret    
80104741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104748:	5b                   	pop    %ebx
    return 0;
80104749:	31 c0                	xor    %eax,%eax
}
8010474b:	5e                   	pop    %esi
8010474c:	5d                   	pop    %ebp
8010474d:	c3                   	ret    
8010474e:	66 90                	xchg   %ax,%ax

80104750 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	8b 75 08             	mov    0x8(%ebp),%esi
80104758:	53                   	push   %ebx
80104759:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010475c:	89 f2                	mov    %esi,%edx
8010475e:	eb 17                	jmp    80104777 <strncpy+0x27>
80104760:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104764:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104767:	83 c2 01             	add    $0x1,%edx
8010476a:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
8010476e:	89 f9                	mov    %edi,%ecx
80104770:	88 4a ff             	mov    %cl,-0x1(%edx)
80104773:	84 c9                	test   %cl,%cl
80104775:	74 09                	je     80104780 <strncpy+0x30>
80104777:	89 c3                	mov    %eax,%ebx
80104779:	83 e8 01             	sub    $0x1,%eax
8010477c:	85 db                	test   %ebx,%ebx
8010477e:	7f e0                	jg     80104760 <strncpy+0x10>
    ;
  while(n-- > 0)
80104780:	89 d1                	mov    %edx,%ecx
80104782:	85 c0                	test   %eax,%eax
80104784:	7e 1d                	jle    801047a3 <strncpy+0x53>
80104786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478d:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80104790:	83 c1 01             	add    $0x1,%ecx
80104793:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104797:	89 c8                	mov    %ecx,%eax
80104799:	f7 d0                	not    %eax
8010479b:	01 d0                	add    %edx,%eax
8010479d:	01 d8                	add    %ebx,%eax
8010479f:	85 c0                	test   %eax,%eax
801047a1:	7f ed                	jg     80104790 <strncpy+0x40>
  return os;
}
801047a3:	5b                   	pop    %ebx
801047a4:	89 f0                	mov    %esi,%eax
801047a6:	5e                   	pop    %esi
801047a7:	5f                   	pop    %edi
801047a8:	5d                   	pop    %ebp
801047a9:	c3                   	ret    
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	8b 55 10             	mov    0x10(%ebp),%edx
801047b7:	8b 75 08             	mov    0x8(%ebp),%esi
801047ba:	53                   	push   %ebx
801047bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801047be:	85 d2                	test   %edx,%edx
801047c0:	7e 25                	jle    801047e7 <safestrcpy+0x37>
801047c2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801047c6:	89 f2                	mov    %esi,%edx
801047c8:	eb 16                	jmp    801047e0 <safestrcpy+0x30>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047d0:	0f b6 08             	movzbl (%eax),%ecx
801047d3:	83 c0 01             	add    $0x1,%eax
801047d6:	83 c2 01             	add    $0x1,%edx
801047d9:	88 4a ff             	mov    %cl,-0x1(%edx)
801047dc:	84 c9                	test   %cl,%cl
801047de:	74 04                	je     801047e4 <safestrcpy+0x34>
801047e0:	39 d8                	cmp    %ebx,%eax
801047e2:	75 ec                	jne    801047d0 <safestrcpy+0x20>
    ;
  *s = 0;
801047e4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801047e7:	89 f0                	mov    %esi,%eax
801047e9:	5b                   	pop    %ebx
801047ea:	5e                   	pop    %esi
801047eb:	5d                   	pop    %ebp
801047ec:	c3                   	ret    
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <strlen>:

int
strlen(const char *s)
{
801047f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047f1:	31 c0                	xor    %eax,%eax
{
801047f3:	89 e5                	mov    %esp,%ebp
801047f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801047f8:	80 3a 00             	cmpb   $0x0,(%edx)
801047fb:	74 0c                	je     80104809 <strlen+0x19>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104807:	75 f7                	jne    80104800 <strlen+0x10>
    ;
  return n;
}
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    

8010480b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010480b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010480f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104813:	55                   	push   %ebp
  pushl %ebx
80104814:	53                   	push   %ebx
  pushl %esi
80104815:	56                   	push   %esi
  pushl %edi
80104816:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104817:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104819:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010481b:	5f                   	pop    %edi
  popl %esi
8010481c:	5e                   	pop    %esi
  popl %ebx
8010481d:	5b                   	pop    %ebx
  popl %ebp
8010481e:	5d                   	pop    %ebp
  ret
8010481f:	c3                   	ret    

80104820 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 04             	sub    $0x4,%esp
80104827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010482a:	e8 31 f0 ff ff       	call   80103860 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010482f:	8b 00                	mov    (%eax),%eax
80104831:	39 d8                	cmp    %ebx,%eax
80104833:	76 1b                	jbe    80104850 <fetchint+0x30>
80104835:	8d 53 04             	lea    0x4(%ebx),%edx
80104838:	39 d0                	cmp    %edx,%eax
8010483a:	72 14                	jb     80104850 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010483c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010483f:	8b 13                	mov    (%ebx),%edx
80104841:	89 10                	mov    %edx,(%eax)
  return 0;
80104843:	31 c0                	xor    %eax,%eax
}
80104845:	83 c4 04             	add    $0x4,%esp
80104848:	5b                   	pop    %ebx
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop
    return -1;
80104850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104855:	eb ee                	jmp    80104845 <fetchint+0x25>
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax

80104860 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010486a:	e8 f1 ef ff ff       	call   80103860 <myproc>

  if(addr >= curproc->sz)
8010486f:	39 18                	cmp    %ebx,(%eax)
80104871:	76 2d                	jbe    801048a0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104873:	8b 55 0c             	mov    0xc(%ebp),%edx
80104876:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104878:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010487a:	39 d3                	cmp    %edx,%ebx
8010487c:	73 22                	jae    801048a0 <fetchstr+0x40>
8010487e:	89 d8                	mov    %ebx,%eax
80104880:	eb 0d                	jmp    8010488f <fetchstr+0x2f>
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104888:	83 c0 01             	add    $0x1,%eax
8010488b:	39 c2                	cmp    %eax,%edx
8010488d:	76 11                	jbe    801048a0 <fetchstr+0x40>
    if(*s == 0)
8010488f:	80 38 00             	cmpb   $0x0,(%eax)
80104892:	75 f4                	jne    80104888 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104894:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104897:	29 d8                	sub    %ebx,%eax
}
80104899:	5b                   	pop    %ebx
8010489a:	5d                   	pop    %ebp
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048a0:	83 c4 04             	add    $0x4,%esp
    return -1;
801048a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a8:	5b                   	pop    %ebx
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    
801048ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048af:	90                   	nop

801048b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048b5:	e8 a6 ef ff ff       	call   80103860 <myproc>
801048ba:	8b 55 08             	mov    0x8(%ebp),%edx
801048bd:	8b 40 18             	mov    0x18(%eax),%eax
801048c0:	8b 40 44             	mov    0x44(%eax),%eax
801048c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801048c6:	e8 95 ef ff ff       	call   80103860 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048cb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ce:	8b 00                	mov    (%eax),%eax
801048d0:	39 c6                	cmp    %eax,%esi
801048d2:	73 1c                	jae    801048f0 <argint+0x40>
801048d4:	8d 53 08             	lea    0x8(%ebx),%edx
801048d7:	39 d0                	cmp    %edx,%eax
801048d9:	72 15                	jb     801048f0 <argint+0x40>
  *ip = *(int*)(addr);
801048db:	8b 45 0c             	mov    0xc(%ebp),%eax
801048de:	8b 53 04             	mov    0x4(%ebx),%edx
801048e1:	89 10                	mov    %edx,(%eax)
  return 0;
801048e3:	31 c0                	xor    %eax,%eax
}
801048e5:	5b                   	pop    %ebx
801048e6:	5e                   	pop    %esi
801048e7:	5d                   	pop    %ebp
801048e8:	c3                   	ret    
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048f5:	eb ee                	jmp    801048e5 <argint+0x35>
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax

80104900 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	83 ec 10             	sub    $0x10,%esp
80104908:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010490b:	e8 50 ef ff ff       	call   80103860 <myproc>
 
  if(argint(n, &i) < 0)
80104910:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104913:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104915:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104918:	50                   	push   %eax
80104919:	ff 75 08             	pushl  0x8(%ebp)
8010491c:	e8 8f ff ff ff       	call   801048b0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104921:	83 c4 10             	add    $0x10,%esp
80104924:	85 c0                	test   %eax,%eax
80104926:	78 28                	js     80104950 <argptr+0x50>
80104928:	85 db                	test   %ebx,%ebx
8010492a:	78 24                	js     80104950 <argptr+0x50>
8010492c:	8b 16                	mov    (%esi),%edx
8010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104931:	39 c2                	cmp    %eax,%edx
80104933:	76 1b                	jbe    80104950 <argptr+0x50>
80104935:	01 c3                	add    %eax,%ebx
80104937:	39 da                	cmp    %ebx,%edx
80104939:	72 15                	jb     80104950 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010493b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010493e:	89 02                	mov    %eax,(%edx)
  return 0;
80104940:	31 c0                	xor    %eax,%eax
}
80104942:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104945:	5b                   	pop    %ebx
80104946:	5e                   	pop    %esi
80104947:	5d                   	pop    %ebp
80104948:	c3                   	ret    
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104955:	eb eb                	jmp    80104942 <argptr+0x42>
80104957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495e:	66 90                	xchg   %ax,%ax

80104960 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104966:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104969:	50                   	push   %eax
8010496a:	ff 75 08             	pushl  0x8(%ebp)
8010496d:	e8 3e ff ff ff       	call   801048b0 <argint>
80104972:	83 c4 10             	add    $0x10,%esp
80104975:	85 c0                	test   %eax,%eax
80104977:	78 17                	js     80104990 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104979:	83 ec 08             	sub    $0x8,%esp
8010497c:	ff 75 0c             	pushl  0xc(%ebp)
8010497f:	ff 75 f4             	pushl  -0xc(%ebp)
80104982:	e8 d9 fe ff ff       	call   80104860 <fetchstr>
80104987:	83 c4 10             	add    $0x10,%esp
}
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104990:	c9                   	leave  
    return -1;
80104991:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104996:	c3                   	ret    
80104997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <syscall>:
[SYS_nps]     sys_nps,
};

void
syscall(void)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049a7:	e8 b4 ee ff ff       	call   80103860 <myproc>
801049ac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049ae:	8b 40 18             	mov    0x18(%eax),%eax
801049b1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049b4:	8d 50 ff             	lea    -0x1(%eax),%edx
801049b7:	83 fa 16             	cmp    $0x16,%edx
801049ba:	77 24                	ja     801049e0 <syscall+0x40>
801049bc:	8b 14 85 e0 76 10 80 	mov    -0x7fef8920(,%eax,4),%edx
801049c3:	85 d2                	test   %edx,%edx
801049c5:	74 19                	je     801049e0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801049c7:	ff d2                	call   *%edx
801049c9:	89 c2                	mov    %eax,%edx
801049cb:	8b 43 18             	mov    0x18(%ebx),%eax
801049ce:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d4:	c9                   	leave  
801049d5:	c3                   	ret    
801049d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801049e0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049e1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801049e4:	50                   	push   %eax
801049e5:	ff 73 10             	pushl  0x10(%ebx)
801049e8:	68 b5 76 10 80       	push   $0x801076b5
801049ed:	e8 ae bc ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801049f2:	8b 43 18             	mov    0x18(%ebx),%eax
801049f5:	83 c4 10             	add    $0x10,%esp
801049f8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801049ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a02:	c9                   	leave  
80104a03:	c3                   	ret    
80104a04:	66 90                	xchg   %ax,%ax
80104a06:	66 90                	xchg   %ax,%ax
80104a08:	66 90                	xchg   %ax,%ax
80104a0a:	66 90                	xchg   %ax,%ax
80104a0c:	66 90                	xchg   %ax,%ax
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104a18:	53                   	push   %ebx
80104a19:	83 ec 44             	sub    $0x44,%esp
80104a1c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a22:	57                   	push   %edi
80104a23:	50                   	push   %eax
{
80104a24:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a27:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a2a:	e8 a1 d5 ff ff       	call   80101fd0 <nameiparent>
80104a2f:	83 c4 10             	add    $0x10,%esp
80104a32:	85 c0                	test   %eax,%eax
80104a34:	0f 84 46 01 00 00    	je     80104b80 <create+0x170>
    return 0;
  ilock(dp);
80104a3a:	83 ec 0c             	sub    $0xc,%esp
80104a3d:	89 c3                	mov    %eax,%ebx
80104a3f:	50                   	push   %eax
80104a40:	e8 cb cc ff ff       	call   80101710 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a45:	83 c4 0c             	add    $0xc,%esp
80104a48:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a4b:	50                   	push   %eax
80104a4c:	57                   	push   %edi
80104a4d:	53                   	push   %ebx
80104a4e:	e8 ed d1 ff ff       	call   80101c40 <dirlookup>
80104a53:	83 c4 10             	add    $0x10,%esp
80104a56:	89 c6                	mov    %eax,%esi
80104a58:	85 c0                	test   %eax,%eax
80104a5a:	74 54                	je     80104ab0 <create+0xa0>
    iunlockput(dp);
80104a5c:	83 ec 0c             	sub    $0xc,%esp
80104a5f:	53                   	push   %ebx
80104a60:	e8 3b cf ff ff       	call   801019a0 <iunlockput>
    ilock(ip);
80104a65:	89 34 24             	mov    %esi,(%esp)
80104a68:	e8 a3 cc ff ff       	call   80101710 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a6d:	83 c4 10             	add    $0x10,%esp
80104a70:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104a75:	75 19                	jne    80104a90 <create+0x80>
80104a77:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104a7c:	75 12                	jne    80104a90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a81:	89 f0                	mov    %esi,%eax
80104a83:	5b                   	pop    %ebx
80104a84:	5e                   	pop    %esi
80104a85:	5f                   	pop    %edi
80104a86:	5d                   	pop    %ebp
80104a87:	c3                   	ret    
80104a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop
    iunlockput(ip);
80104a90:	83 ec 0c             	sub    $0xc,%esp
80104a93:	56                   	push   %esi
    return 0;
80104a94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104a96:	e8 05 cf ff ff       	call   801019a0 <iunlockput>
    return 0;
80104a9b:	83 c4 10             	add    $0x10,%esp
}
80104a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa1:	89 f0                	mov    %esi,%eax
80104aa3:	5b                   	pop    %ebx
80104aa4:	5e                   	pop    %esi
80104aa5:	5f                   	pop    %edi
80104aa6:	5d                   	pop    %ebp
80104aa7:	c3                   	ret    
80104aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ab0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ab4:	83 ec 08             	sub    $0x8,%esp
80104ab7:	50                   	push   %eax
80104ab8:	ff 33                	pushl  (%ebx)
80104aba:	e8 e1 ca ff ff       	call   801015a0 <ialloc>
80104abf:	83 c4 10             	add    $0x10,%esp
80104ac2:	89 c6                	mov    %eax,%esi
80104ac4:	85 c0                	test   %eax,%eax
80104ac6:	0f 84 cd 00 00 00    	je     80104b99 <create+0x189>
  ilock(ip);
80104acc:	83 ec 0c             	sub    $0xc,%esp
80104acf:	50                   	push   %eax
80104ad0:	e8 3b cc ff ff       	call   80101710 <ilock>
  ip->major = major;
80104ad5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ad9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104add:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ae1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ae5:	b8 01 00 00 00       	mov    $0x1,%eax
80104aea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104aee:	89 34 24             	mov    %esi,(%esp)
80104af1:	e8 6a cb ff ff       	call   80101660 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104af6:	83 c4 10             	add    $0x10,%esp
80104af9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104afe:	74 30                	je     80104b30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b00:	83 ec 04             	sub    $0x4,%esp
80104b03:	ff 76 04             	pushl  0x4(%esi)
80104b06:	57                   	push   %edi
80104b07:	53                   	push   %ebx
80104b08:	e8 e3 d3 ff ff       	call   80101ef0 <dirlink>
80104b0d:	83 c4 10             	add    $0x10,%esp
80104b10:	85 c0                	test   %eax,%eax
80104b12:	78 78                	js     80104b8c <create+0x17c>
  iunlockput(dp);
80104b14:	83 ec 0c             	sub    $0xc,%esp
80104b17:	53                   	push   %ebx
80104b18:	e8 83 ce ff ff       	call   801019a0 <iunlockput>
  return ip;
80104b1d:	83 c4 10             	add    $0x10,%esp
}
80104b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b23:	89 f0                	mov    %esi,%eax
80104b25:	5b                   	pop    %ebx
80104b26:	5e                   	pop    %esi
80104b27:	5f                   	pop    %edi
80104b28:	5d                   	pop    %ebp
80104b29:	c3                   	ret    
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b38:	53                   	push   %ebx
80104b39:	e8 22 cb ff ff       	call   80101660 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b3e:	83 c4 0c             	add    $0xc,%esp
80104b41:	ff 76 04             	pushl  0x4(%esi)
80104b44:	68 5c 77 10 80       	push   $0x8010775c
80104b49:	56                   	push   %esi
80104b4a:	e8 a1 d3 ff ff       	call   80101ef0 <dirlink>
80104b4f:	83 c4 10             	add    $0x10,%esp
80104b52:	85 c0                	test   %eax,%eax
80104b54:	78 18                	js     80104b6e <create+0x15e>
80104b56:	83 ec 04             	sub    $0x4,%esp
80104b59:	ff 73 04             	pushl  0x4(%ebx)
80104b5c:	68 5b 77 10 80       	push   $0x8010775b
80104b61:	56                   	push   %esi
80104b62:	e8 89 d3 ff ff       	call   80101ef0 <dirlink>
80104b67:	83 c4 10             	add    $0x10,%esp
80104b6a:	85 c0                	test   %eax,%eax
80104b6c:	79 92                	jns    80104b00 <create+0xf0>
      panic("create dots");
80104b6e:	83 ec 0c             	sub    $0xc,%esp
80104b71:	68 4f 77 10 80       	push   $0x8010774f
80104b76:	e8 05 b8 ff ff       	call   80100380 <panic>
80104b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b7f:	90                   	nop
}
80104b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104b83:	31 f6                	xor    %esi,%esi
}
80104b85:	5b                   	pop    %ebx
80104b86:	89 f0                	mov    %esi,%eax
80104b88:	5e                   	pop    %esi
80104b89:	5f                   	pop    %edi
80104b8a:	5d                   	pop    %ebp
80104b8b:	c3                   	ret    
    panic("create: dirlink");
80104b8c:	83 ec 0c             	sub    $0xc,%esp
80104b8f:	68 5e 77 10 80       	push   $0x8010775e
80104b94:	e8 e7 b7 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104b99:	83 ec 0c             	sub    $0xc,%esp
80104b9c:	68 40 77 10 80       	push   $0x80107740
80104ba1:	e8 da b7 ff ff       	call   80100380 <panic>
80104ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bad:	8d 76 00             	lea    0x0(%esi),%esi

80104bb0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	89 d6                	mov    %edx,%esi
80104bb6:	53                   	push   %ebx
80104bb7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104bb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bbc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bbf:	50                   	push   %eax
80104bc0:	6a 00                	push   $0x0
80104bc2:	e8 e9 fc ff ff       	call   801048b0 <argint>
80104bc7:	83 c4 10             	add    $0x10,%esp
80104bca:	85 c0                	test   %eax,%eax
80104bcc:	78 2a                	js     80104bf8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104bd2:	77 24                	ja     80104bf8 <argfd.constprop.0+0x48>
80104bd4:	e8 87 ec ff ff       	call   80103860 <myproc>
80104bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bdc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104be0:	85 c0                	test   %eax,%eax
80104be2:	74 14                	je     80104bf8 <argfd.constprop.0+0x48>
  if(pfd)
80104be4:	85 db                	test   %ebx,%ebx
80104be6:	74 02                	je     80104bea <argfd.constprop.0+0x3a>
    *pfd = fd;
80104be8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104bea:	89 06                	mov    %eax,(%esi)
  return 0;
80104bec:	31 c0                	xor    %eax,%eax
}
80104bee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf1:	5b                   	pop    %ebx
80104bf2:	5e                   	pop    %esi
80104bf3:	5d                   	pop    %ebp
80104bf4:	c3                   	ret    
80104bf5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bfd:	eb ef                	jmp    80104bee <argfd.constprop.0+0x3e>
80104bff:	90                   	nop

80104c00 <sys_dup>:
{
80104c00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c01:	31 c0                	xor    %eax,%eax
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	56                   	push   %esi
80104c06:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c07:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c0a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c0d:	e8 9e ff ff ff       	call   80104bb0 <argfd.constprop.0>
80104c12:	85 c0                	test   %eax,%eax
80104c14:	78 1a                	js     80104c30 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104c16:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c19:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c1b:	e8 40 ec ff ff       	call   80103860 <myproc>
    if(curproc->ofile[fd] == 0){
80104c20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c24:	85 d2                	test   %edx,%edx
80104c26:	74 18                	je     80104c40 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104c28:	83 c3 01             	add    $0x1,%ebx
80104c2b:	83 fb 10             	cmp    $0x10,%ebx
80104c2e:	75 f0                	jne    80104c20 <sys_dup+0x20>
}
80104c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c38:	89 d8                	mov    %ebx,%eax
80104c3a:	5b                   	pop    %ebx
80104c3b:	5e                   	pop    %esi
80104c3c:	5d                   	pop    %ebp
80104c3d:	c3                   	ret    
80104c3e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104c40:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c44:	83 ec 0c             	sub    $0xc,%esp
80104c47:	ff 75 f4             	pushl  -0xc(%ebp)
80104c4a:	e8 11 c2 ff ff       	call   80100e60 <filedup>
  return fd;
80104c4f:	83 c4 10             	add    $0x10,%esp
}
80104c52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c55:	89 d8                	mov    %ebx,%eax
80104c57:	5b                   	pop    %ebx
80104c58:	5e                   	pop    %esi
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    
80104c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop

80104c60 <sys_read>:
{
80104c60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c61:	31 c0                	xor    %eax,%eax
{
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c6b:	e8 40 ff ff ff       	call   80104bb0 <argfd.constprop.0>
80104c70:	85 c0                	test   %eax,%eax
80104c72:	78 4c                	js     80104cc0 <sys_read+0x60>
80104c74:	83 ec 08             	sub    $0x8,%esp
80104c77:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c7a:	50                   	push   %eax
80104c7b:	6a 02                	push   $0x2
80104c7d:	e8 2e fc ff ff       	call   801048b0 <argint>
80104c82:	83 c4 10             	add    $0x10,%esp
80104c85:	85 c0                	test   %eax,%eax
80104c87:	78 37                	js     80104cc0 <sys_read+0x60>
80104c89:	83 ec 04             	sub    $0x4,%esp
80104c8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c8f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c92:	50                   	push   %eax
80104c93:	6a 01                	push   $0x1
80104c95:	e8 66 fc ff ff       	call   80104900 <argptr>
80104c9a:	83 c4 10             	add    $0x10,%esp
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	78 1f                	js     80104cc0 <sys_read+0x60>
  return fileread(f, p, n);
80104ca1:	83 ec 04             	sub    $0x4,%esp
80104ca4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ca7:	ff 75 f4             	pushl  -0xc(%ebp)
80104caa:	ff 75 ec             	pushl  -0x14(%ebp)
80104cad:	e8 2e c3 ff ff       	call   80100fe0 <fileread>
80104cb2:	83 c4 10             	add    $0x10,%esp
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax
80104cc0:	c9                   	leave  
    return -1;
80104cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc6:	c3                   	ret    
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <sys_write>:
{
80104cd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cd1:	31 c0                	xor    %eax,%eax
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cdb:	e8 d0 fe ff ff       	call   80104bb0 <argfd.constprop.0>
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	78 4c                	js     80104d30 <sys_write+0x60>
80104ce4:	83 ec 08             	sub    $0x8,%esp
80104ce7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cea:	50                   	push   %eax
80104ceb:	6a 02                	push   $0x2
80104ced:	e8 be fb ff ff       	call   801048b0 <argint>
80104cf2:	83 c4 10             	add    $0x10,%esp
80104cf5:	85 c0                	test   %eax,%eax
80104cf7:	78 37                	js     80104d30 <sys_write+0x60>
80104cf9:	83 ec 04             	sub    $0x4,%esp
80104cfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cff:	ff 75 f0             	pushl  -0x10(%ebp)
80104d02:	50                   	push   %eax
80104d03:	6a 01                	push   $0x1
80104d05:	e8 f6 fb ff ff       	call   80104900 <argptr>
80104d0a:	83 c4 10             	add    $0x10,%esp
80104d0d:	85 c0                	test   %eax,%eax
80104d0f:	78 1f                	js     80104d30 <sys_write+0x60>
  return filewrite(f, p, n);
80104d11:	83 ec 04             	sub    $0x4,%esp
80104d14:	ff 75 f0             	pushl  -0x10(%ebp)
80104d17:	ff 75 f4             	pushl  -0xc(%ebp)
80104d1a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d1d:	e8 4e c3 ff ff       	call   80101070 <filewrite>
80104d22:	83 c4 10             	add    $0x10,%esp
}
80104d25:	c9                   	leave  
80104d26:	c3                   	ret    
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax
80104d30:	c9                   	leave  
    return -1;
80104d31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d36:	c3                   	ret    
80104d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <sys_close>:
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d4c:	e8 5f fe ff ff       	call   80104bb0 <argfd.constprop.0>
80104d51:	85 c0                	test   %eax,%eax
80104d53:	78 2b                	js     80104d80 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d55:	e8 06 eb ff ff       	call   80103860 <myproc>
80104d5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d5d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104d60:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d67:	00 
  fileclose(f);
80104d68:	ff 75 f4             	pushl  -0xc(%ebp)
80104d6b:	e8 40 c1 ff ff       	call   80100eb0 <fileclose>
  return 0;
80104d70:	83 c4 10             	add    $0x10,%esp
80104d73:	31 c0                	xor    %eax,%eax
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax
80104d80:	c9                   	leave  
    return -1;
80104d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d86:	c3                   	ret    
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <sys_fstat>:
{
80104d90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d91:	31 c0                	xor    %eax,%eax
{
80104d93:	89 e5                	mov    %esp,%ebp
80104d95:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d98:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d9b:	e8 10 fe ff ff       	call   80104bb0 <argfd.constprop.0>
80104da0:	85 c0                	test   %eax,%eax
80104da2:	78 2c                	js     80104dd0 <sys_fstat+0x40>
80104da4:	83 ec 04             	sub    $0x4,%esp
80104da7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104daa:	6a 14                	push   $0x14
80104dac:	50                   	push   %eax
80104dad:	6a 01                	push   $0x1
80104daf:	e8 4c fb ff ff       	call   80104900 <argptr>
80104db4:	83 c4 10             	add    $0x10,%esp
80104db7:	85 c0                	test   %eax,%eax
80104db9:	78 15                	js     80104dd0 <sys_fstat+0x40>
  return filestat(f, st);
80104dbb:	83 ec 08             	sub    $0x8,%esp
80104dbe:	ff 75 f4             	pushl  -0xc(%ebp)
80104dc1:	ff 75 f0             	pushl  -0x10(%ebp)
80104dc4:	e8 c7 c1 ff ff       	call   80100f90 <filestat>
80104dc9:	83 c4 10             	add    $0x10,%esp
}
80104dcc:	c9                   	leave  
80104dcd:	c3                   	ret    
80104dce:	66 90                	xchg   %ax,%ax
80104dd0:	c9                   	leave  
    return -1;
80104dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd6:	c3                   	ret    
80104dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <sys_link>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104de5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104de8:	53                   	push   %ebx
80104de9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dec:	50                   	push   %eax
80104ded:	6a 00                	push   $0x0
80104def:	e8 6c fb ff ff       	call   80104960 <argstr>
80104df4:	83 c4 10             	add    $0x10,%esp
80104df7:	85 c0                	test   %eax,%eax
80104df9:	0f 88 fb 00 00 00    	js     80104efa <sys_link+0x11a>
80104dff:	83 ec 08             	sub    $0x8,%esp
80104e02:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e05:	50                   	push   %eax
80104e06:	6a 01                	push   $0x1
80104e08:	e8 53 fb ff ff       	call   80104960 <argstr>
80104e0d:	83 c4 10             	add    $0x10,%esp
80104e10:	85 c0                	test   %eax,%eax
80104e12:	0f 88 e2 00 00 00    	js     80104efa <sys_link+0x11a>
  begin_op();
80104e18:	e8 53 de ff ff       	call   80102c70 <begin_op>
  if((ip = namei(old)) == 0){
80104e1d:	83 ec 0c             	sub    $0xc,%esp
80104e20:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e23:	e8 88 d1 ff ff       	call   80101fb0 <namei>
80104e28:	83 c4 10             	add    $0x10,%esp
80104e2b:	89 c3                	mov    %eax,%ebx
80104e2d:	85 c0                	test   %eax,%eax
80104e2f:	0f 84 e4 00 00 00    	je     80104f19 <sys_link+0x139>
  ilock(ip);
80104e35:	83 ec 0c             	sub    $0xc,%esp
80104e38:	50                   	push   %eax
80104e39:	e8 d2 c8 ff ff       	call   80101710 <ilock>
  if(ip->type == T_DIR){
80104e3e:	83 c4 10             	add    $0x10,%esp
80104e41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e46:	0f 84 b5 00 00 00    	je     80104f01 <sys_link+0x121>
  iupdate(ip);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104e4f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104e54:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e57:	53                   	push   %ebx
80104e58:	e8 03 c8 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
80104e5d:	89 1c 24             	mov    %ebx,(%esp)
80104e60:	e8 8b c9 ff ff       	call   801017f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e65:	58                   	pop    %eax
80104e66:	5a                   	pop    %edx
80104e67:	57                   	push   %edi
80104e68:	ff 75 d0             	pushl  -0x30(%ebp)
80104e6b:	e8 60 d1 ff ff       	call   80101fd0 <nameiparent>
80104e70:	83 c4 10             	add    $0x10,%esp
80104e73:	89 c6                	mov    %eax,%esi
80104e75:	85 c0                	test   %eax,%eax
80104e77:	74 5b                	je     80104ed4 <sys_link+0xf4>
  ilock(dp);
80104e79:	83 ec 0c             	sub    $0xc,%esp
80104e7c:	50                   	push   %eax
80104e7d:	e8 8e c8 ff ff       	call   80101710 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e82:	8b 03                	mov    (%ebx),%eax
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	39 06                	cmp    %eax,(%esi)
80104e89:	75 3d                	jne    80104ec8 <sys_link+0xe8>
80104e8b:	83 ec 04             	sub    $0x4,%esp
80104e8e:	ff 73 04             	pushl  0x4(%ebx)
80104e91:	57                   	push   %edi
80104e92:	56                   	push   %esi
80104e93:	e8 58 d0 ff ff       	call   80101ef0 <dirlink>
80104e98:	83 c4 10             	add    $0x10,%esp
80104e9b:	85 c0                	test   %eax,%eax
80104e9d:	78 29                	js     80104ec8 <sys_link+0xe8>
  iunlockput(dp);
80104e9f:	83 ec 0c             	sub    $0xc,%esp
80104ea2:	56                   	push   %esi
80104ea3:	e8 f8 ca ff ff       	call   801019a0 <iunlockput>
  iput(ip);
80104ea8:	89 1c 24             	mov    %ebx,(%esp)
80104eab:	e8 90 c9 ff ff       	call   80101840 <iput>
  end_op();
80104eb0:	e8 2b de ff ff       	call   80102ce0 <end_op>
  return 0;
80104eb5:	83 c4 10             	add    $0x10,%esp
80104eb8:	31 c0                	xor    %eax,%eax
}
80104eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ebd:	5b                   	pop    %ebx
80104ebe:	5e                   	pop    %esi
80104ebf:	5f                   	pop    %edi
80104ec0:	5d                   	pop    %ebp
80104ec1:	c3                   	ret    
80104ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ec8:	83 ec 0c             	sub    $0xc,%esp
80104ecb:	56                   	push   %esi
80104ecc:	e8 cf ca ff ff       	call   801019a0 <iunlockput>
    goto bad;
80104ed1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ed4:	83 ec 0c             	sub    $0xc,%esp
80104ed7:	53                   	push   %ebx
80104ed8:	e8 33 c8 ff ff       	call   80101710 <ilock>
  ip->nlink--;
80104edd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ee2:	89 1c 24             	mov    %ebx,(%esp)
80104ee5:	e8 76 c7 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104eea:	89 1c 24             	mov    %ebx,(%esp)
80104eed:	e8 ae ca ff ff       	call   801019a0 <iunlockput>
  end_op();
80104ef2:	e8 e9 dd ff ff       	call   80102ce0 <end_op>
  return -1;
80104ef7:	83 c4 10             	add    $0x10,%esp
80104efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eff:	eb b9                	jmp    80104eba <sys_link+0xda>
    iunlockput(ip);
80104f01:	83 ec 0c             	sub    $0xc,%esp
80104f04:	53                   	push   %ebx
80104f05:	e8 96 ca ff ff       	call   801019a0 <iunlockput>
    end_op();
80104f0a:	e8 d1 dd ff ff       	call   80102ce0 <end_op>
    return -1;
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f17:	eb a1                	jmp    80104eba <sys_link+0xda>
    end_op();
80104f19:	e8 c2 dd ff ff       	call   80102ce0 <end_op>
    return -1;
80104f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f23:	eb 95                	jmp    80104eba <sys_link+0xda>
80104f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f30 <sys_unlink>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f35:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f38:	53                   	push   %ebx
80104f39:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104f3c:	50                   	push   %eax
80104f3d:	6a 00                	push   $0x0
80104f3f:	e8 1c fa ff ff       	call   80104960 <argstr>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	0f 88 91 01 00 00    	js     801050e0 <sys_unlink+0x1b0>
  begin_op();
80104f4f:	e8 1c dd ff ff       	call   80102c70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f54:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f57:	83 ec 08             	sub    $0x8,%esp
80104f5a:	53                   	push   %ebx
80104f5b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f5e:	e8 6d d0 ff ff       	call   80101fd0 <nameiparent>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	89 c6                	mov    %eax,%esi
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	0f 84 7a 01 00 00    	je     801050ea <sys_unlink+0x1ba>
  ilock(dp);
80104f70:	83 ec 0c             	sub    $0xc,%esp
80104f73:	50                   	push   %eax
80104f74:	e8 97 c7 ff ff       	call   80101710 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f79:	58                   	pop    %eax
80104f7a:	5a                   	pop    %edx
80104f7b:	68 5c 77 10 80       	push   $0x8010775c
80104f80:	53                   	push   %ebx
80104f81:	e8 9a cc ff ff       	call   80101c20 <namecmp>
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	85 c0                	test   %eax,%eax
80104f8b:	0f 84 0f 01 00 00    	je     801050a0 <sys_unlink+0x170>
80104f91:	83 ec 08             	sub    $0x8,%esp
80104f94:	68 5b 77 10 80       	push   $0x8010775b
80104f99:	53                   	push   %ebx
80104f9a:	e8 81 cc ff ff       	call   80101c20 <namecmp>
80104f9f:	83 c4 10             	add    $0x10,%esp
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	0f 84 f6 00 00 00    	je     801050a0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104faa:	83 ec 04             	sub    $0x4,%esp
80104fad:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fb0:	50                   	push   %eax
80104fb1:	53                   	push   %ebx
80104fb2:	56                   	push   %esi
80104fb3:	e8 88 cc ff ff       	call   80101c40 <dirlookup>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	89 c3                	mov    %eax,%ebx
80104fbd:	85 c0                	test   %eax,%eax
80104fbf:	0f 84 db 00 00 00    	je     801050a0 <sys_unlink+0x170>
  ilock(ip);
80104fc5:	83 ec 0c             	sub    $0xc,%esp
80104fc8:	50                   	push   %eax
80104fc9:	e8 42 c7 ff ff       	call   80101710 <ilock>
  if(ip->nlink < 1)
80104fce:	83 c4 10             	add    $0x10,%esp
80104fd1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104fd6:	0f 8e 37 01 00 00    	jle    80105113 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104fdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fe1:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104fe4:	74 6a                	je     80105050 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104fe6:	83 ec 04             	sub    $0x4,%esp
80104fe9:	6a 10                	push   $0x10
80104feb:	6a 00                	push   $0x0
80104fed:	57                   	push   %edi
80104fee:	e8 fd f5 ff ff       	call   801045f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ff3:	6a 10                	push   $0x10
80104ff5:	ff 75 c4             	pushl  -0x3c(%ebp)
80104ff8:	57                   	push   %edi
80104ff9:	56                   	push   %esi
80104ffa:	e8 f1 ca ff ff       	call   80101af0 <writei>
80104fff:	83 c4 20             	add    $0x20,%esp
80105002:	83 f8 10             	cmp    $0x10,%eax
80105005:	0f 85 fb 00 00 00    	jne    80105106 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
8010500b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105010:	0f 84 aa 00 00 00    	je     801050c0 <sys_unlink+0x190>
  iunlockput(dp);
80105016:	83 ec 0c             	sub    $0xc,%esp
80105019:	56                   	push   %esi
8010501a:	e8 81 c9 ff ff       	call   801019a0 <iunlockput>
  ip->nlink--;
8010501f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105024:	89 1c 24             	mov    %ebx,(%esp)
80105027:	e8 34 c6 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
8010502c:	89 1c 24             	mov    %ebx,(%esp)
8010502f:	e8 6c c9 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105034:	e8 a7 dc ff ff       	call   80102ce0 <end_op>
  return 0;
80105039:	83 c4 10             	add    $0x10,%esp
8010503c:	31 c0                	xor    %eax,%eax
}
8010503e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105041:	5b                   	pop    %ebx
80105042:	5e                   	pop    %esi
80105043:	5f                   	pop    %edi
80105044:	5d                   	pop    %ebp
80105045:	c3                   	ret    
80105046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105050:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105054:	76 90                	jbe    80104fe6 <sys_unlink+0xb6>
80105056:	ba 20 00 00 00       	mov    $0x20,%edx
8010505b:	eb 0f                	jmp    8010506c <sys_unlink+0x13c>
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
80105060:	83 c2 10             	add    $0x10,%edx
80105063:	39 53 58             	cmp    %edx,0x58(%ebx)
80105066:	0f 86 7a ff ff ff    	jbe    80104fe6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010506c:	6a 10                	push   $0x10
8010506e:	52                   	push   %edx
8010506f:	57                   	push   %edi
80105070:	53                   	push   %ebx
80105071:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105074:	e8 77 c9 ff ff       	call   801019f0 <readi>
80105079:	83 c4 10             	add    $0x10,%esp
8010507c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010507f:	83 f8 10             	cmp    $0x10,%eax
80105082:	75 75                	jne    801050f9 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105084:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105089:	74 d5                	je     80105060 <sys_unlink+0x130>
    iunlockput(ip);
8010508b:	83 ec 0c             	sub    $0xc,%esp
8010508e:	53                   	push   %ebx
8010508f:	e8 0c c9 ff ff       	call   801019a0 <iunlockput>
    goto bad;
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	56                   	push   %esi
801050a4:	e8 f7 c8 ff ff       	call   801019a0 <iunlockput>
  end_op();
801050a9:	e8 32 dc ff ff       	call   80102ce0 <end_op>
  return -1;
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b6:	eb 86                	jmp    8010503e <sys_unlink+0x10e>
801050b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop
    iupdate(dp);
801050c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801050c3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801050c8:	56                   	push   %esi
801050c9:	e8 92 c5 ff ff       	call   80101660 <iupdate>
801050ce:	83 c4 10             	add    $0x10,%esp
801050d1:	e9 40 ff ff ff       	jmp    80105016 <sys_unlink+0xe6>
801050d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e5:	e9 54 ff ff ff       	jmp    8010503e <sys_unlink+0x10e>
    end_op();
801050ea:	e8 f1 db ff ff       	call   80102ce0 <end_op>
    return -1;
801050ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f4:	e9 45 ff ff ff       	jmp    8010503e <sys_unlink+0x10e>
      panic("isdirempty: readi");
801050f9:	83 ec 0c             	sub    $0xc,%esp
801050fc:	68 80 77 10 80       	push   $0x80107780
80105101:	e8 7a b2 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105106:	83 ec 0c             	sub    $0xc,%esp
80105109:	68 92 77 10 80       	push   $0x80107792
8010510e:	e8 6d b2 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105113:	83 ec 0c             	sub    $0xc,%esp
80105116:	68 6e 77 10 80       	push   $0x8010776e
8010511b:	e8 60 b2 ff ff       	call   80100380 <panic>

80105120 <sys_open>:

int
sys_open(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105125:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105128:	53                   	push   %ebx
80105129:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010512c:	50                   	push   %eax
8010512d:	6a 00                	push   $0x0
8010512f:	e8 2c f8 ff ff       	call   80104960 <argstr>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	0f 88 8e 00 00 00    	js     801051cd <sys_open+0xad>
8010513f:	83 ec 08             	sub    $0x8,%esp
80105142:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105145:	50                   	push   %eax
80105146:	6a 01                	push   $0x1
80105148:	e8 63 f7 ff ff       	call   801048b0 <argint>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	78 79                	js     801051cd <sys_open+0xad>
    return -1;

  begin_op();
80105154:	e8 17 db ff ff       	call   80102c70 <begin_op>

  if(omode & O_CREATE){
80105159:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010515d:	75 79                	jne    801051d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	ff 75 e0             	pushl  -0x20(%ebp)
80105165:	e8 46 ce ff ff       	call   80101fb0 <namei>
8010516a:	83 c4 10             	add    $0x10,%esp
8010516d:	89 c6                	mov    %eax,%esi
8010516f:	85 c0                	test   %eax,%eax
80105171:	0f 84 7e 00 00 00    	je     801051f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105177:	83 ec 0c             	sub    $0xc,%esp
8010517a:	50                   	push   %eax
8010517b:	e8 90 c5 ff ff       	call   80101710 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105180:	83 c4 10             	add    $0x10,%esp
80105183:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105188:	0f 84 c2 00 00 00    	je     80105250 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010518e:	e8 5d bc ff ff       	call   80100df0 <filealloc>
80105193:	89 c7                	mov    %eax,%edi
80105195:	85 c0                	test   %eax,%eax
80105197:	74 23                	je     801051bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105199:	e8 c2 e6 ff ff       	call   80103860 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010519e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801051a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051a4:	85 d2                	test   %edx,%edx
801051a6:	74 60                	je     80105208 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801051a8:	83 c3 01             	add    $0x1,%ebx
801051ab:	83 fb 10             	cmp    $0x10,%ebx
801051ae:	75 f0                	jne    801051a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	57                   	push   %edi
801051b4:	e8 f7 bc ff ff       	call   80100eb0 <fileclose>
801051b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	56                   	push   %esi
801051c0:	e8 db c7 ff ff       	call   801019a0 <iunlockput>
    end_op();
801051c5:	e8 16 db ff ff       	call   80102ce0 <end_op>
    return -1;
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051d2:	eb 6d                	jmp    80105241 <sys_open+0x121>
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051de:	31 c9                	xor    %ecx,%ecx
801051e0:	ba 02 00 00 00       	mov    $0x2,%edx
801051e5:	6a 00                	push   $0x0
801051e7:	e8 24 f8 ff ff       	call   80104a10 <create>
    if(ip == 0){
801051ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801051ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801051f1:	85 c0                	test   %eax,%eax
801051f3:	75 99                	jne    8010518e <sys_open+0x6e>
      end_op();
801051f5:	e8 e6 da ff ff       	call   80102ce0 <end_op>
      return -1;
801051fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051ff:	eb 40                	jmp    80105241 <sys_open+0x121>
80105201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105208:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010520b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010520f:	56                   	push   %esi
80105210:	e8 db c5 ff ff       	call   801017f0 <iunlock>
  end_op();
80105215:	e8 c6 da ff ff       	call   80102ce0 <end_op>

  f->type = FD_INODE;
8010521a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105220:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105223:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105226:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105229:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010522b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105232:	f7 d0                	not    %eax
80105234:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105237:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010523a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010523d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105241:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105244:	89 d8                	mov    %ebx,%eax
80105246:	5b                   	pop    %ebx
80105247:	5e                   	pop    %esi
80105248:	5f                   	pop    %edi
80105249:	5d                   	pop    %ebp
8010524a:	c3                   	ret    
8010524b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010524f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105250:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105253:	85 c9                	test   %ecx,%ecx
80105255:	0f 84 33 ff ff ff    	je     8010518e <sys_open+0x6e>
8010525b:	e9 5c ff ff ff       	jmp    801051bc <sys_open+0x9c>

80105260 <sys_mkdir>:

int
sys_mkdir(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105266:	e8 05 da ff ff       	call   80102c70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010526b:	83 ec 08             	sub    $0x8,%esp
8010526e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105271:	50                   	push   %eax
80105272:	6a 00                	push   $0x0
80105274:	e8 e7 f6 ff ff       	call   80104960 <argstr>
80105279:	83 c4 10             	add    $0x10,%esp
8010527c:	85 c0                	test   %eax,%eax
8010527e:	78 30                	js     801052b0 <sys_mkdir+0x50>
80105280:	83 ec 0c             	sub    $0xc,%esp
80105283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105286:	31 c9                	xor    %ecx,%ecx
80105288:	ba 01 00 00 00       	mov    $0x1,%edx
8010528d:	6a 00                	push   $0x0
8010528f:	e8 7c f7 ff ff       	call   80104a10 <create>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	74 15                	je     801052b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010529b:	83 ec 0c             	sub    $0xc,%esp
8010529e:	50                   	push   %eax
8010529f:	e8 fc c6 ff ff       	call   801019a0 <iunlockput>
  end_op();
801052a4:	e8 37 da ff ff       	call   80102ce0 <end_op>
  return 0;
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	31 c0                	xor    %eax,%eax
}
801052ae:	c9                   	leave  
801052af:	c3                   	ret    
    end_op();
801052b0:	e8 2b da ff ff       	call   80102ce0 <end_op>
    return -1;
801052b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ba:	c9                   	leave  
801052bb:	c3                   	ret    
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_mknod>:

int
sys_mknod(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052c6:	e8 a5 d9 ff ff       	call   80102c70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052cb:	83 ec 08             	sub    $0x8,%esp
801052ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052d1:	50                   	push   %eax
801052d2:	6a 00                	push   $0x0
801052d4:	e8 87 f6 ff ff       	call   80104960 <argstr>
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	85 c0                	test   %eax,%eax
801052de:	78 60                	js     80105340 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801052e0:	83 ec 08             	sub    $0x8,%esp
801052e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e6:	50                   	push   %eax
801052e7:	6a 01                	push   $0x1
801052e9:	e8 c2 f5 ff ff       	call   801048b0 <argint>
  if((argstr(0, &path)) < 0 ||
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	85 c0                	test   %eax,%eax
801052f3:	78 4b                	js     80105340 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801052f5:	83 ec 08             	sub    $0x8,%esp
801052f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fb:	50                   	push   %eax
801052fc:	6a 02                	push   $0x2
801052fe:	e8 ad f5 ff ff       	call   801048b0 <argint>
     argint(1, &major) < 0 ||
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	78 36                	js     80105340 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010530a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010530e:	83 ec 0c             	sub    $0xc,%esp
80105311:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105315:	ba 03 00 00 00       	mov    $0x3,%edx
8010531a:	50                   	push   %eax
8010531b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010531e:	e8 ed f6 ff ff       	call   80104a10 <create>
     argint(2, &minor) < 0 ||
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	74 16                	je     80105340 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010532a:	83 ec 0c             	sub    $0xc,%esp
8010532d:	50                   	push   %eax
8010532e:	e8 6d c6 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105333:	e8 a8 d9 ff ff       	call   80102ce0 <end_op>
  return 0;
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	31 c0                	xor    %eax,%eax
}
8010533d:	c9                   	leave  
8010533e:	c3                   	ret    
8010533f:	90                   	nop
    end_op();
80105340:	e8 9b d9 ff ff       	call   80102ce0 <end_op>
    return -1;
80105345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010534a:	c9                   	leave  
8010534b:	c3                   	ret    
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105350 <sys_chdir>:

int
sys_chdir(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
80105355:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105358:	e8 03 e5 ff ff       	call   80103860 <myproc>
8010535d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010535f:	e8 0c d9 ff ff       	call   80102c70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105364:	83 ec 08             	sub    $0x8,%esp
80105367:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536a:	50                   	push   %eax
8010536b:	6a 00                	push   $0x0
8010536d:	e8 ee f5 ff ff       	call   80104960 <argstr>
80105372:	83 c4 10             	add    $0x10,%esp
80105375:	85 c0                	test   %eax,%eax
80105377:	78 77                	js     801053f0 <sys_chdir+0xa0>
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	ff 75 f4             	pushl  -0xc(%ebp)
8010537f:	e8 2c cc ff ff       	call   80101fb0 <namei>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	89 c3                	mov    %eax,%ebx
80105389:	85 c0                	test   %eax,%eax
8010538b:	74 63                	je     801053f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	50                   	push   %eax
80105391:	e8 7a c3 ff ff       	call   80101710 <ilock>
  if(ip->type != T_DIR){
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010539e:	75 30                	jne    801053d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	53                   	push   %ebx
801053a4:	e8 47 c4 ff ff       	call   801017f0 <iunlock>
  iput(curproc->cwd);
801053a9:	58                   	pop    %eax
801053aa:	ff 76 68             	pushl  0x68(%esi)
801053ad:	e8 8e c4 ff ff       	call   80101840 <iput>
  end_op();
801053b2:	e8 29 d9 ff ff       	call   80102ce0 <end_op>
  curproc->cwd = ip;
801053b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053ba:	83 c4 10             	add    $0x10,%esp
801053bd:	31 c0                	xor    %eax,%eax
}
801053bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
801053c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	53                   	push   %ebx
801053d4:	e8 c7 c5 ff ff       	call   801019a0 <iunlockput>
    end_op();
801053d9:	e8 02 d9 ff ff       	call   80102ce0 <end_op>
    return -1;
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e6:	eb d7                	jmp    801053bf <sys_chdir+0x6f>
801053e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
    end_op();
801053f0:	e8 eb d8 ff ff       	call   80102ce0 <end_op>
    return -1;
801053f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053fa:	eb c3                	jmp    801053bf <sys_chdir+0x6f>
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_exec>:

int
sys_exec(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105405:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010540b:	53                   	push   %ebx
8010540c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105412:	50                   	push   %eax
80105413:	6a 00                	push   $0x0
80105415:	e8 46 f5 ff ff       	call   80104960 <argstr>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	0f 88 87 00 00 00    	js     801054ac <sys_exec+0xac>
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010542e:	50                   	push   %eax
8010542f:	6a 01                	push   $0x1
80105431:	e8 7a f4 ff ff       	call   801048b0 <argint>
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	85 c0                	test   %eax,%eax
8010543b:	78 6f                	js     801054ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010543d:	83 ec 04             	sub    $0x4,%esp
80105440:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105446:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105448:	68 80 00 00 00       	push   $0x80
8010544d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105453:	6a 00                	push   $0x0
80105455:	50                   	push   %eax
80105456:	e8 95 f1 ff ff       	call   801045f0 <memset>
8010545b:	83 c4 10             	add    $0x10,%esp
8010545e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105460:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105466:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
8010546d:	83 ec 08             	sub    $0x8,%esp
80105470:	57                   	push   %edi
80105471:	01 f0                	add    %esi,%eax
80105473:	50                   	push   %eax
80105474:	e8 a7 f3 ff ff       	call   80104820 <fetchint>
80105479:	83 c4 10             	add    $0x10,%esp
8010547c:	85 c0                	test   %eax,%eax
8010547e:	78 2c                	js     801054ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105480:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105486:	85 c0                	test   %eax,%eax
80105488:	74 36                	je     801054c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010548a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105496:	52                   	push   %edx
80105497:	50                   	push   %eax
80105498:	e8 c3 f3 ff ff       	call   80104860 <fetchstr>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 08                	js     801054ac <sys_exec+0xac>
  for(i=0;; i++){
801054a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054a7:	83 fb 20             	cmp    $0x20,%ebx
801054aa:	75 b4                	jne    80105460 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801054ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801054af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b4:	5b                   	pop    %ebx
801054b5:	5e                   	pop    %esi
801054b6:	5f                   	pop    %edi
801054b7:	5d                   	pop    %ebp
801054b8:	c3                   	ret    
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801054c0:	83 ec 08             	sub    $0x8,%esp
801054c3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801054c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801054d0:	00 00 00 00 
  return exec(path, argv);
801054d4:	50                   	push   %eax
801054d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801054db:	e8 90 b5 ff ff       	call   80100a70 <exec>
801054e0:	83 c4 10             	add    $0x10,%esp
}
801054e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e6:	5b                   	pop    %ebx
801054e7:	5e                   	pop    %esi
801054e8:	5f                   	pop    %edi
801054e9:	5d                   	pop    %ebp
801054ea:	c3                   	ret    
801054eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ef:	90                   	nop

801054f0 <sys_pipe>:

int
sys_pipe(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801054f8:	53                   	push   %ebx
801054f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054fc:	6a 08                	push   $0x8
801054fe:	50                   	push   %eax
801054ff:	6a 00                	push   $0x0
80105501:	e8 fa f3 ff ff       	call   80104900 <argptr>
80105506:	83 c4 10             	add    $0x10,%esp
80105509:	85 c0                	test   %eax,%eax
8010550b:	78 4a                	js     80105557 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010550d:	83 ec 08             	sub    $0x8,%esp
80105510:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105513:	50                   	push   %eax
80105514:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105517:	50                   	push   %eax
80105518:	e8 f3 dd ff ff       	call   80103310 <pipealloc>
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	85 c0                	test   %eax,%eax
80105522:	78 33                	js     80105557 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105524:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105527:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105529:	e8 32 e3 ff ff       	call   80103860 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010552e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105530:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105534:	85 f6                	test   %esi,%esi
80105536:	74 28                	je     80105560 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105538:	83 c3 01             	add    $0x1,%ebx
8010553b:	83 fb 10             	cmp    $0x10,%ebx
8010553e:	75 f0                	jne    80105530 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	ff 75 e0             	pushl  -0x20(%ebp)
80105546:	e8 65 b9 ff ff       	call   80100eb0 <fileclose>
    fileclose(wf);
8010554b:	58                   	pop    %eax
8010554c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010554f:	e8 5c b9 ff ff       	call   80100eb0 <fileclose>
    return -1;
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555c:	eb 53                	jmp    801055b1 <sys_pipe+0xc1>
8010555e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105560:	8d 73 08             	lea    0x8(%ebx),%esi
80105563:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010556a:	e8 f1 e2 ff ff       	call   80103860 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010556f:	31 d2                	xor    %edx,%edx
80105571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105578:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010557c:	85 c9                	test   %ecx,%ecx
8010557e:	74 20                	je     801055a0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105580:	83 c2 01             	add    $0x1,%edx
80105583:	83 fa 10             	cmp    $0x10,%edx
80105586:	75 f0                	jne    80105578 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105588:	e8 d3 e2 ff ff       	call   80103860 <myproc>
8010558d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105594:	00 
80105595:	eb a9                	jmp    80105540 <sys_pipe+0x50>
80105597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801055a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801055a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055af:	31 c0                	xor    %eax,%eax
}
801055b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b4:	5b                   	pop    %ebx
801055b5:	5e                   	pop    %esi
801055b6:	5f                   	pop    %edi
801055b7:	5d                   	pop    %ebp
801055b8:	c3                   	ret    
801055b9:	66 90                	xchg   %ax,%ax
801055bb:	66 90                	xchg   %ax,%ax
801055bd:	66 90                	xchg   %ax,%ax
801055bf:	90                   	nop

801055c0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801055c0:	e9 3b e4 ff ff       	jmp    80103a00 <fork>
801055c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_exit>:
}

int
sys_exit(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055d6:	e8 a5 e6 ff ff       	call   80103c80 <exit>
  return 0;  // not reached
}
801055db:	31 c0                	xor    %eax,%eax
801055dd:	c9                   	leave  
801055de:	c3                   	ret    
801055df:	90                   	nop

801055e0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801055e0:	e9 db e8 ff ff       	jmp    80103ec0 <wait>
801055e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_kill>:
}

int
sys_kill(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f9:	50                   	push   %eax
801055fa:	6a 00                	push   $0x0
801055fc:	e8 af f2 ff ff       	call   801048b0 <argint>
80105601:	83 c4 10             	add    $0x10,%esp
80105604:	85 c0                	test   %eax,%eax
80105606:	78 18                	js     80105620 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105608:	83 ec 0c             	sub    $0xc,%esp
8010560b:	ff 75 f4             	pushl  -0xc(%ebp)
8010560e:	e8 fd e9 ff ff       	call   80104010 <kill>
80105613:	83 c4 10             	add    $0x10,%esp
}
80105616:	c9                   	leave  
80105617:	c3                   	ret    
80105618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
80105620:	c9                   	leave  
    return -1;
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105626:	c3                   	ret    
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_getpid>:

int
sys_getpid(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105636:	e8 25 e2 ff ff       	call   80103860 <myproc>
8010563b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010563e:	c9                   	leave  
8010563f:	c3                   	ret    

80105640 <sys_sbrk>:

int
sys_sbrk(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105644:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105647:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010564a:	50                   	push   %eax
8010564b:	6a 00                	push   $0x0
8010564d:	e8 5e f2 ff ff       	call   801048b0 <argint>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	85 c0                	test   %eax,%eax
80105657:	78 27                	js     80105680 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105659:	e8 02 e2 ff ff       	call   80103860 <myproc>
  if(growproc(n) < 0)
8010565e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105661:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105663:	ff 75 f4             	pushl  -0xc(%ebp)
80105666:	e8 15 e3 ff ff       	call   80103980 <growproc>
8010566b:	83 c4 10             	add    $0x10,%esp
8010566e:	85 c0                	test   %eax,%eax
80105670:	78 0e                	js     80105680 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105672:	89 d8                	mov    %ebx,%eax
80105674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105677:	c9                   	leave  
80105678:	c3                   	ret    
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105680:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105685:	eb eb                	jmp    80105672 <sys_sbrk+0x32>
80105687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568e:	66 90                	xchg   %ax,%ax

80105690 <sys_sleep>:

int
sys_sleep(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105694:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105697:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010569a:	50                   	push   %eax
8010569b:	6a 00                	push   $0x0
8010569d:	e8 0e f2 ff ff       	call   801048b0 <argint>
801056a2:	83 c4 10             	add    $0x10,%esp
801056a5:	85 c0                	test   %eax,%eax
801056a7:	0f 88 8a 00 00 00    	js     80105737 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	68 60 4c 11 80       	push   $0x80114c60
801056b5:	e8 c6 ed ff ff       	call   80104480 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801056bd:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	85 d2                	test   %edx,%edx
801056c8:	75 27                	jne    801056f1 <sys_sleep+0x61>
801056ca:	eb 54                	jmp    80105720 <sys_sleep+0x90>
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056d0:	83 ec 08             	sub    $0x8,%esp
801056d3:	68 60 4c 11 80       	push   $0x80114c60
801056d8:	68 a0 54 11 80       	push   $0x801154a0
801056dd:	e8 1e e7 ff ff       	call   80103e00 <sleep>
  while(ticks - ticks0 < n){
801056e2:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801056e7:	83 c4 10             	add    $0x10,%esp
801056ea:	29 d8                	sub    %ebx,%eax
801056ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801056ef:	73 2f                	jae    80105720 <sys_sleep+0x90>
    if(myproc()->killed){
801056f1:	e8 6a e1 ff ff       	call   80103860 <myproc>
801056f6:	8b 40 24             	mov    0x24(%eax),%eax
801056f9:	85 c0                	test   %eax,%eax
801056fb:	74 d3                	je     801056d0 <sys_sleep+0x40>
      release(&tickslock);
801056fd:	83 ec 0c             	sub    $0xc,%esp
80105700:	68 60 4c 11 80       	push   $0x80114c60
80105705:	e8 96 ee ff ff       	call   801045a0 <release>
  }
  release(&tickslock);
  return 0;
}
8010570a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	68 60 4c 11 80       	push   $0x80114c60
80105728:	e8 73 ee ff ff       	call   801045a0 <release>
  return 0;
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	31 c0                	xor    %eax,%eax
}
80105732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105735:	c9                   	leave  
80105736:	c3                   	ret    
    return -1;
80105737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573c:	eb f4                	jmp    80105732 <sys_sleep+0xa2>
8010573e:	66 90                	xchg   %ax,%ax

80105740 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	53                   	push   %ebx
80105744:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105747:	68 60 4c 11 80       	push   $0x80114c60
8010574c:	e8 2f ed ff ff       	call   80104480 <acquire>
  xticks = ticks;
80105751:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105757:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010575e:	e8 3d ee ff ff       	call   801045a0 <release>
  return xticks;
}
80105763:	89 d8                	mov    %ebx,%eax
80105765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105768:	c9                   	leave  
80105769:	c3                   	ret    
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105770 <sys_cps>:

int 
sys_cps(void){
	return cps(); 
80105770:	e9 db e9 ff ff       	jmp    80104150 <cps>
80105775:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_nps>:
}

int sys_nps(void){
	return nps(); 
80105780:	e9 7b ea ff ff       	jmp    80104200 <nps>

80105785 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105785:	1e                   	push   %ds
  pushl %es
80105786:	06                   	push   %es
  pushl %fs
80105787:	0f a0                	push   %fs
  pushl %gs
80105789:	0f a8                	push   %gs
  pushal
8010578b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010578c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105790:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105792:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105794:	54                   	push   %esp
  call trap
80105795:	e8 c6 00 00 00       	call   80105860 <trap>
  addl $4, %esp
8010579a:	83 c4 04             	add    $0x4,%esp

8010579d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010579d:	61                   	popa   
  popl %gs
8010579e:	0f a9                	pop    %gs
  popl %fs
801057a0:	0f a1                	pop    %fs
  popl %es
801057a2:	07                   	pop    %es
  popl %ds
801057a3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057a4:	83 c4 08             	add    $0x8,%esp
  iret
801057a7:	cf                   	iret   
801057a8:	66 90                	xchg   %ax,%ax
801057aa:	66 90                	xchg   %ax,%ax
801057ac:	66 90                	xchg   %ax,%ax
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801057b1:	31 c0                	xor    %eax,%eax
{
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	83 ec 08             	sub    $0x8,%esp
801057b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801057c0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801057c7:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
801057ce:	08 00 00 8e 
801057d2:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801057d9:	80 
801057da:	c1 ea 10             	shr    $0x10,%edx
801057dd:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801057e4:	80 
  for(i = 0; i < 256; i++)
801057e5:	83 c0 01             	add    $0x1,%eax
801057e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801057ed:	75 d1                	jne    801057c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801057ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057f2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801057f7:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
801057fe:	00 00 ef 
  initlock(&tickslock, "time");
80105801:	68 a1 77 10 80       	push   $0x801077a1
80105806:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010580b:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105811:	c1 e8 10             	shr    $0x10,%eax
80105814:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
8010581a:	e8 61 eb ff ff       	call   80104380 <initlock>
}
8010581f:	83 c4 10             	add    $0x10,%esp
80105822:	c9                   	leave  
80105823:	c3                   	ret    
80105824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop

80105830 <idtinit>:

void
idtinit(void)
{
80105830:	55                   	push   %ebp
  pd[0] = size-1;
80105831:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105836:	89 e5                	mov    %esp,%ebp
80105838:	83 ec 10             	sub    $0x10,%esp
8010583b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010583f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105844:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105848:	c1 e8 10             	shr    $0x10,%eax
8010584b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010584f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105852:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105855:	c9                   	leave  
80105856:	c3                   	ret    
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax

80105860 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
80105866:	83 ec 1c             	sub    $0x1c,%esp
80105869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010586c:	8b 43 30             	mov    0x30(%ebx),%eax
8010586f:	83 f8 40             	cmp    $0x40,%eax
80105872:	0f 84 c0 01 00 00    	je     80105a38 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105878:	83 e8 20             	sub    $0x20,%eax
8010587b:	83 f8 1f             	cmp    $0x1f,%eax
8010587e:	77 07                	ja     80105887 <trap+0x27>
80105880:	ff 24 85 48 78 10 80 	jmp    *-0x7fef87b8(,%eax,4)
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105887:	e8 d4 df ff ff       	call   80103860 <myproc>
8010588c:	8b 7b 38             	mov    0x38(%ebx),%edi
8010588f:	85 c0                	test   %eax,%eax
80105891:	0f 84 f0 01 00 00    	je     80105a87 <trap+0x227>
80105897:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010589b:	0f 84 e6 01 00 00    	je     80105a87 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058a1:	0f 20 d1             	mov    %cr2,%ecx
801058a4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058a7:	e8 94 df ff ff       	call   80103840 <cpuid>
801058ac:	8b 73 30             	mov    0x30(%ebx),%esi
801058af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801058b2:	8b 43 34             	mov    0x34(%ebx),%eax
801058b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058b8:	e8 a3 df ff ff       	call   80103860 <myproc>
801058bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801058c0:	e8 9b df ff ff       	call   80103860 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058c5:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801058c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058cb:	51                   	push   %ecx
801058cc:	57                   	push   %edi
801058cd:	52                   	push   %edx
801058ce:	ff 75 e4             	pushl  -0x1c(%ebp)
801058d1:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801058d2:	8b 75 e0             	mov    -0x20(%ebp),%esi
801058d5:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058d8:	56                   	push   %esi
801058d9:	ff 70 10             	pushl  0x10(%eax)
801058dc:	68 04 78 10 80       	push   $0x80107804
801058e1:	e8 ba ad ff ff       	call   801006a0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801058e6:	83 c4 20             	add    $0x20,%esp
801058e9:	e8 72 df ff ff       	call   80103860 <myproc>
801058ee:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058f5:	e8 66 df ff ff       	call   80103860 <myproc>
801058fa:	85 c0                	test   %eax,%eax
801058fc:	74 1d                	je     8010591b <trap+0xbb>
801058fe:	e8 5d df ff ff       	call   80103860 <myproc>
80105903:	8b 50 24             	mov    0x24(%eax),%edx
80105906:	85 d2                	test   %edx,%edx
80105908:	74 11                	je     8010591b <trap+0xbb>
8010590a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010590e:	83 e0 03             	and    $0x3,%eax
80105911:	66 83 f8 03          	cmp    $0x3,%ax
80105915:	0f 84 55 01 00 00    	je     80105a70 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010591b:	e8 40 df ff ff       	call   80103860 <myproc>
80105920:	85 c0                	test   %eax,%eax
80105922:	74 0f                	je     80105933 <trap+0xd3>
80105924:	e8 37 df ff ff       	call   80103860 <myproc>
80105929:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010592d:	0f 84 ed 00 00 00    	je     80105a20 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105933:	e8 28 df ff ff       	call   80103860 <myproc>
80105938:	85 c0                	test   %eax,%eax
8010593a:	74 1d                	je     80105959 <trap+0xf9>
8010593c:	e8 1f df ff ff       	call   80103860 <myproc>
80105941:	8b 40 24             	mov    0x24(%eax),%eax
80105944:	85 c0                	test   %eax,%eax
80105946:	74 11                	je     80105959 <trap+0xf9>
80105948:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010594c:	83 e0 03             	and    $0x3,%eax
8010594f:	66 83 f8 03          	cmp    $0x3,%ax
80105953:	0f 84 08 01 00 00    	je     80105a61 <trap+0x201>
    exit();
}
80105959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010595c:	5b                   	pop    %ebx
8010595d:	5e                   	pop    %esi
8010595e:	5f                   	pop    %edi
8010595f:	5d                   	pop    %ebp
80105960:	c3                   	ret    
    ideintr();
80105961:	e8 ea c7 ff ff       	call   80102150 <ideintr>
    lapiceoi();
80105966:	e8 b5 ce ff ff       	call   80102820 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010596b:	e8 f0 de ff ff       	call   80103860 <myproc>
80105970:	85 c0                	test   %eax,%eax
80105972:	75 8a                	jne    801058fe <trap+0x9e>
80105974:	eb a5                	jmp    8010591b <trap+0xbb>
    if(cpuid() == 0){
80105976:	e8 c5 de ff ff       	call   80103840 <cpuid>
8010597b:	85 c0                	test   %eax,%eax
8010597d:	75 e7                	jne    80105966 <trap+0x106>
      acquire(&tickslock);
8010597f:	83 ec 0c             	sub    $0xc,%esp
80105982:	68 60 4c 11 80       	push   $0x80114c60
80105987:	e8 f4 ea ff ff       	call   80104480 <acquire>
      wakeup(&ticks);
8010598c:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105993:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
8010599a:	e8 11 e6 ff ff       	call   80103fb0 <wakeup>
      release(&tickslock);
8010599f:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801059a6:	e8 f5 eb ff ff       	call   801045a0 <release>
801059ab:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801059ae:	eb b6                	jmp    80105966 <trap+0x106>
    kbdintr();
801059b0:	e8 2b cd ff ff       	call   801026e0 <kbdintr>
    lapiceoi();
801059b5:	e8 66 ce ff ff       	call   80102820 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059ba:	e8 a1 de ff ff       	call   80103860 <myproc>
801059bf:	85 c0                	test   %eax,%eax
801059c1:	0f 85 37 ff ff ff    	jne    801058fe <trap+0x9e>
801059c7:	e9 4f ff ff ff       	jmp    8010591b <trap+0xbb>
    uartintr();
801059cc:	e8 4f 02 00 00       	call   80105c20 <uartintr>
    lapiceoi();
801059d1:	e8 4a ce ff ff       	call   80102820 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d6:	e8 85 de ff ff       	call   80103860 <myproc>
801059db:	85 c0                	test   %eax,%eax
801059dd:	0f 85 1b ff ff ff    	jne    801058fe <trap+0x9e>
801059e3:	e9 33 ff ff ff       	jmp    8010591b <trap+0xbb>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059e8:	8b 7b 38             	mov    0x38(%ebx),%edi
801059eb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801059ef:	e8 4c de ff ff       	call   80103840 <cpuid>
801059f4:	57                   	push   %edi
801059f5:	56                   	push   %esi
801059f6:	50                   	push   %eax
801059f7:	68 ac 77 10 80       	push   $0x801077ac
801059fc:	e8 9f ac ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105a01:	e8 1a ce ff ff       	call   80102820 <lapiceoi>
    break;
80105a06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a09:	e8 52 de ff ff       	call   80103860 <myproc>
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	0f 85 e8 fe ff ff    	jne    801058fe <trap+0x9e>
80105a16:	e9 00 ff ff ff       	jmp    8010591b <trap+0xbb>
80105a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a1f:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
80105a20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105a24:	0f 85 09 ff ff ff    	jne    80105933 <trap+0xd3>
    yield();
80105a2a:	e8 81 e3 ff ff       	call   80103db0 <yield>
80105a2f:	e9 ff fe ff ff       	jmp    80105933 <trap+0xd3>
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105a38:	e8 23 de ff ff       	call   80103860 <myproc>
80105a3d:	8b 70 24             	mov    0x24(%eax),%esi
80105a40:	85 f6                	test   %esi,%esi
80105a42:	75 3c                	jne    80105a80 <trap+0x220>
    myproc()->tf = tf;
80105a44:	e8 17 de ff ff       	call   80103860 <myproc>
80105a49:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105a4c:	e8 4f ef ff ff       	call   801049a0 <syscall>
    if(myproc()->killed)
80105a51:	e8 0a de ff ff       	call   80103860 <myproc>
80105a56:	8b 48 24             	mov    0x24(%eax),%ecx
80105a59:	85 c9                	test   %ecx,%ecx
80105a5b:	0f 84 f8 fe ff ff    	je     80105959 <trap+0xf9>
}
80105a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a64:	5b                   	pop    %ebx
80105a65:	5e                   	pop    %esi
80105a66:	5f                   	pop    %edi
80105a67:	5d                   	pop    %ebp
      exit();
80105a68:	e9 13 e2 ff ff       	jmp    80103c80 <exit>
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a70:	e8 0b e2 ff ff       	call   80103c80 <exit>
80105a75:	e9 a1 fe ff ff       	jmp    8010591b <trap+0xbb>
80105a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105a80:	e8 fb e1 ff ff       	call   80103c80 <exit>
80105a85:	eb bd                	jmp    80105a44 <trap+0x1e4>
80105a87:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a8a:	e8 b1 dd ff ff       	call   80103840 <cpuid>
80105a8f:	83 ec 0c             	sub    $0xc,%esp
80105a92:	56                   	push   %esi
80105a93:	57                   	push   %edi
80105a94:	50                   	push   %eax
80105a95:	ff 73 30             	pushl  0x30(%ebx)
80105a98:	68 d0 77 10 80       	push   $0x801077d0
80105a9d:	e8 fe ab ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105aa2:	83 c4 14             	add    $0x14,%esp
80105aa5:	68 a6 77 10 80       	push   $0x801077a6
80105aaa:	e8 d1 a8 ff ff       	call   80100380 <panic>
80105aaf:	90                   	nop

80105ab0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ab0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	74 17                	je     80105ad0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ab9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105abe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105abf:	a8 01                	test   $0x1,%al
80105ac1:	74 0d                	je     80105ad0 <uartgetc+0x20>
80105ac3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ac8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ac9:	0f b6 c0             	movzbl %al,%eax
80105acc:	c3                   	ret    
80105acd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad5:	c3                   	ret    
80105ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105add:	8d 76 00             	lea    0x0(%esi),%esi

80105ae0 <uartputc.part.0>:
uartputc(int c)
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	89 c7                	mov    %eax,%edi
80105ae6:	56                   	push   %esi
80105ae7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105aec:	53                   	push   %ebx
80105aed:	bb 80 00 00 00       	mov    $0x80,%ebx
80105af2:	83 ec 0c             	sub    $0xc,%esp
80105af5:	eb 1b                	jmp    80105b12 <uartputc.part.0+0x32>
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	6a 0a                	push   $0xa
80105b05:	e8 36 cd ff ff       	call   80102840 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	83 eb 01             	sub    $0x1,%ebx
80105b10:	74 07                	je     80105b19 <uartputc.part.0+0x39>
80105b12:	89 f2                	mov    %esi,%edx
80105b14:	ec                   	in     (%dx),%al
80105b15:	a8 20                	test   $0x20,%al
80105b17:	74 e7                	je     80105b00 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b1e:	89 f8                	mov    %edi,%eax
80105b20:	ee                   	out    %al,(%dx)
}
80105b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b24:	5b                   	pop    %ebx
80105b25:	5e                   	pop    %esi
80105b26:	5f                   	pop    %edi
80105b27:	5d                   	pop    %ebp
80105b28:	c3                   	ret    
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b30 <uartinit>:
{
80105b30:	55                   	push   %ebp
80105b31:	31 c9                	xor    %ecx,%ecx
80105b33:	89 c8                	mov    %ecx,%eax
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	57                   	push   %edi
80105b38:	56                   	push   %esi
80105b39:	53                   	push   %ebx
80105b3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b3f:	89 da                	mov    %ebx,%edx
80105b41:	83 ec 0c             	sub    $0xc,%esp
80105b44:	ee                   	out    %al,(%dx)
80105b45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b4f:	89 fa                	mov    %edi,%edx
80105b51:	ee                   	out    %al,(%dx)
80105b52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b5c:	ee                   	out    %al,(%dx)
80105b5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b62:	89 c8                	mov    %ecx,%eax
80105b64:	89 f2                	mov    %esi,%edx
80105b66:	ee                   	out    %al,(%dx)
80105b67:	b8 03 00 00 00       	mov    $0x3,%eax
80105b6c:	89 fa                	mov    %edi,%edx
80105b6e:	ee                   	out    %al,(%dx)
80105b6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b74:	89 c8                	mov    %ecx,%eax
80105b76:	ee                   	out    %al,(%dx)
80105b77:	b8 01 00 00 00       	mov    $0x1,%eax
80105b7c:	89 f2                	mov    %esi,%edx
80105b7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105b85:	3c ff                	cmp    $0xff,%al
80105b87:	74 56                	je     80105bdf <uartinit+0xaf>
  uart = 1;
80105b89:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b90:	00 00 00 
80105b93:	89 da                	mov    %ebx,%edx
80105b95:	ec                   	in     (%dx),%al
80105b96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b9b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105b9c:	83 ec 08             	sub    $0x8,%esp
80105b9f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105ba4:	bb c8 78 10 80       	mov    $0x801078c8,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ba9:	6a 00                	push   $0x0
80105bab:	6a 04                	push   $0x4
80105bad:	e8 de c7 ff ff       	call   80102390 <ioapicenable>
80105bb2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105bb5:	b8 78 00 00 00       	mov    $0x78,%eax
80105bba:	eb 08                	jmp    80105bc4 <uartinit+0x94>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105bc4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105bca:	85 d2                	test   %edx,%edx
80105bcc:	74 08                	je     80105bd6 <uartinit+0xa6>
    uartputc(*p);
80105bce:	0f be c0             	movsbl %al,%eax
80105bd1:	e8 0a ff ff ff       	call   80105ae0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105bd6:	89 f0                	mov    %esi,%eax
80105bd8:	83 c3 01             	add    $0x1,%ebx
80105bdb:	84 c0                	test   %al,%al
80105bdd:	75 e1                	jne    80105bc0 <uartinit+0x90>
}
80105bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be2:	5b                   	pop    %ebx
80105be3:	5e                   	pop    %esi
80105be4:	5f                   	pop    %edi
80105be5:	5d                   	pop    %ebp
80105be6:	c3                   	ret    
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <uartputc>:
{
80105bf0:	55                   	push   %ebp
  if(!uart)
80105bf1:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105bf7:	89 e5                	mov    %esp,%ebp
80105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105bfc:	85 d2                	test   %edx,%edx
80105bfe:	74 10                	je     80105c10 <uartputc+0x20>
}
80105c00:	5d                   	pop    %ebp
80105c01:	e9 da fe ff ff       	jmp    80105ae0 <uartputc.part.0>
80105c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
80105c10:	5d                   	pop    %ebp
80105c11:	c3                   	ret    
80105c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c20 <uartintr>:

void
uartintr(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c26:	68 b0 5a 10 80       	push   $0x80105ab0
80105c2b:	e8 20 ac ff ff       	call   80100850 <consoleintr>
}
80105c30:	83 c4 10             	add    $0x10,%esp
80105c33:	c9                   	leave  
80105c34:	c3                   	ret    

80105c35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $0
80105c37:	6a 00                	push   $0x0
  jmp alltraps
80105c39:	e9 47 fb ff ff       	jmp    80105785 <alltraps>

80105c3e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $1
80105c40:	6a 01                	push   $0x1
  jmp alltraps
80105c42:	e9 3e fb ff ff       	jmp    80105785 <alltraps>

80105c47 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $2
80105c49:	6a 02                	push   $0x2
  jmp alltraps
80105c4b:	e9 35 fb ff ff       	jmp    80105785 <alltraps>

80105c50 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $3
80105c52:	6a 03                	push   $0x3
  jmp alltraps
80105c54:	e9 2c fb ff ff       	jmp    80105785 <alltraps>

80105c59 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $4
80105c5b:	6a 04                	push   $0x4
  jmp alltraps
80105c5d:	e9 23 fb ff ff       	jmp    80105785 <alltraps>

80105c62 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $5
80105c64:	6a 05                	push   $0x5
  jmp alltraps
80105c66:	e9 1a fb ff ff       	jmp    80105785 <alltraps>

80105c6b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $6
80105c6d:	6a 06                	push   $0x6
  jmp alltraps
80105c6f:	e9 11 fb ff ff       	jmp    80105785 <alltraps>

80105c74 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $7
80105c76:	6a 07                	push   $0x7
  jmp alltraps
80105c78:	e9 08 fb ff ff       	jmp    80105785 <alltraps>

80105c7d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c7d:	6a 08                	push   $0x8
  jmp alltraps
80105c7f:	e9 01 fb ff ff       	jmp    80105785 <alltraps>

80105c84 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $9
80105c86:	6a 09                	push   $0x9
  jmp alltraps
80105c88:	e9 f8 fa ff ff       	jmp    80105785 <alltraps>

80105c8d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c8d:	6a 0a                	push   $0xa
  jmp alltraps
80105c8f:	e9 f1 fa ff ff       	jmp    80105785 <alltraps>

80105c94 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c94:	6a 0b                	push   $0xb
  jmp alltraps
80105c96:	e9 ea fa ff ff       	jmp    80105785 <alltraps>

80105c9b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c9b:	6a 0c                	push   $0xc
  jmp alltraps
80105c9d:	e9 e3 fa ff ff       	jmp    80105785 <alltraps>

80105ca2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ca2:	6a 0d                	push   $0xd
  jmp alltraps
80105ca4:	e9 dc fa ff ff       	jmp    80105785 <alltraps>

80105ca9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ca9:	6a 0e                	push   $0xe
  jmp alltraps
80105cab:	e9 d5 fa ff ff       	jmp    80105785 <alltraps>

80105cb0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $15
80105cb2:	6a 0f                	push   $0xf
  jmp alltraps
80105cb4:	e9 cc fa ff ff       	jmp    80105785 <alltraps>

80105cb9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $16
80105cbb:	6a 10                	push   $0x10
  jmp alltraps
80105cbd:	e9 c3 fa ff ff       	jmp    80105785 <alltraps>

80105cc2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cc2:	6a 11                	push   $0x11
  jmp alltraps
80105cc4:	e9 bc fa ff ff       	jmp    80105785 <alltraps>

80105cc9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cc9:	6a 00                	push   $0x0
  pushl $18
80105ccb:	6a 12                	push   $0x12
  jmp alltraps
80105ccd:	e9 b3 fa ff ff       	jmp    80105785 <alltraps>

80105cd2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $19
80105cd4:	6a 13                	push   $0x13
  jmp alltraps
80105cd6:	e9 aa fa ff ff       	jmp    80105785 <alltraps>

80105cdb <vector20>:
.globl vector20
vector20:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $20
80105cdd:	6a 14                	push   $0x14
  jmp alltraps
80105cdf:	e9 a1 fa ff ff       	jmp    80105785 <alltraps>

80105ce4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ce4:	6a 00                	push   $0x0
  pushl $21
80105ce6:	6a 15                	push   $0x15
  jmp alltraps
80105ce8:	e9 98 fa ff ff       	jmp    80105785 <alltraps>

80105ced <vector22>:
.globl vector22
vector22:
  pushl $0
80105ced:	6a 00                	push   $0x0
  pushl $22
80105cef:	6a 16                	push   $0x16
  jmp alltraps
80105cf1:	e9 8f fa ff ff       	jmp    80105785 <alltraps>

80105cf6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $23
80105cf8:	6a 17                	push   $0x17
  jmp alltraps
80105cfa:	e9 86 fa ff ff       	jmp    80105785 <alltraps>

80105cff <vector24>:
.globl vector24
vector24:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $24
80105d01:	6a 18                	push   $0x18
  jmp alltraps
80105d03:	e9 7d fa ff ff       	jmp    80105785 <alltraps>

80105d08 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d08:	6a 00                	push   $0x0
  pushl $25
80105d0a:	6a 19                	push   $0x19
  jmp alltraps
80105d0c:	e9 74 fa ff ff       	jmp    80105785 <alltraps>

80105d11 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d11:	6a 00                	push   $0x0
  pushl $26
80105d13:	6a 1a                	push   $0x1a
  jmp alltraps
80105d15:	e9 6b fa ff ff       	jmp    80105785 <alltraps>

80105d1a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $27
80105d1c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d1e:	e9 62 fa ff ff       	jmp    80105785 <alltraps>

80105d23 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $28
80105d25:	6a 1c                	push   $0x1c
  jmp alltraps
80105d27:	e9 59 fa ff ff       	jmp    80105785 <alltraps>

80105d2c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d2c:	6a 00                	push   $0x0
  pushl $29
80105d2e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d30:	e9 50 fa ff ff       	jmp    80105785 <alltraps>

80105d35 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d35:	6a 00                	push   $0x0
  pushl $30
80105d37:	6a 1e                	push   $0x1e
  jmp alltraps
80105d39:	e9 47 fa ff ff       	jmp    80105785 <alltraps>

80105d3e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $31
80105d40:	6a 1f                	push   $0x1f
  jmp alltraps
80105d42:	e9 3e fa ff ff       	jmp    80105785 <alltraps>

80105d47 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $32
80105d49:	6a 20                	push   $0x20
  jmp alltraps
80105d4b:	e9 35 fa ff ff       	jmp    80105785 <alltraps>

80105d50 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d50:	6a 00                	push   $0x0
  pushl $33
80105d52:	6a 21                	push   $0x21
  jmp alltraps
80105d54:	e9 2c fa ff ff       	jmp    80105785 <alltraps>

80105d59 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $34
80105d5b:	6a 22                	push   $0x22
  jmp alltraps
80105d5d:	e9 23 fa ff ff       	jmp    80105785 <alltraps>

80105d62 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $35
80105d64:	6a 23                	push   $0x23
  jmp alltraps
80105d66:	e9 1a fa ff ff       	jmp    80105785 <alltraps>

80105d6b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $36
80105d6d:	6a 24                	push   $0x24
  jmp alltraps
80105d6f:	e9 11 fa ff ff       	jmp    80105785 <alltraps>

80105d74 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d74:	6a 00                	push   $0x0
  pushl $37
80105d76:	6a 25                	push   $0x25
  jmp alltraps
80105d78:	e9 08 fa ff ff       	jmp    80105785 <alltraps>

80105d7d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d7d:	6a 00                	push   $0x0
  pushl $38
80105d7f:	6a 26                	push   $0x26
  jmp alltraps
80105d81:	e9 ff f9 ff ff       	jmp    80105785 <alltraps>

80105d86 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $39
80105d88:	6a 27                	push   $0x27
  jmp alltraps
80105d8a:	e9 f6 f9 ff ff       	jmp    80105785 <alltraps>

80105d8f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $40
80105d91:	6a 28                	push   $0x28
  jmp alltraps
80105d93:	e9 ed f9 ff ff       	jmp    80105785 <alltraps>

80105d98 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d98:	6a 00                	push   $0x0
  pushl $41
80105d9a:	6a 29                	push   $0x29
  jmp alltraps
80105d9c:	e9 e4 f9 ff ff       	jmp    80105785 <alltraps>

80105da1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105da1:	6a 00                	push   $0x0
  pushl $42
80105da3:	6a 2a                	push   $0x2a
  jmp alltraps
80105da5:	e9 db f9 ff ff       	jmp    80105785 <alltraps>

80105daa <vector43>:
.globl vector43
vector43:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $43
80105dac:	6a 2b                	push   $0x2b
  jmp alltraps
80105dae:	e9 d2 f9 ff ff       	jmp    80105785 <alltraps>

80105db3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $44
80105db5:	6a 2c                	push   $0x2c
  jmp alltraps
80105db7:	e9 c9 f9 ff ff       	jmp    80105785 <alltraps>

80105dbc <vector45>:
.globl vector45
vector45:
  pushl $0
80105dbc:	6a 00                	push   $0x0
  pushl $45
80105dbe:	6a 2d                	push   $0x2d
  jmp alltraps
80105dc0:	e9 c0 f9 ff ff       	jmp    80105785 <alltraps>

80105dc5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105dc5:	6a 00                	push   $0x0
  pushl $46
80105dc7:	6a 2e                	push   $0x2e
  jmp alltraps
80105dc9:	e9 b7 f9 ff ff       	jmp    80105785 <alltraps>

80105dce <vector47>:
.globl vector47
vector47:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $47
80105dd0:	6a 2f                	push   $0x2f
  jmp alltraps
80105dd2:	e9 ae f9 ff ff       	jmp    80105785 <alltraps>

80105dd7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $48
80105dd9:	6a 30                	push   $0x30
  jmp alltraps
80105ddb:	e9 a5 f9 ff ff       	jmp    80105785 <alltraps>

80105de0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105de0:	6a 00                	push   $0x0
  pushl $49
80105de2:	6a 31                	push   $0x31
  jmp alltraps
80105de4:	e9 9c f9 ff ff       	jmp    80105785 <alltraps>

80105de9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $50
80105deb:	6a 32                	push   $0x32
  jmp alltraps
80105ded:	e9 93 f9 ff ff       	jmp    80105785 <alltraps>

80105df2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $51
80105df4:	6a 33                	push   $0x33
  jmp alltraps
80105df6:	e9 8a f9 ff ff       	jmp    80105785 <alltraps>

80105dfb <vector52>:
.globl vector52
vector52:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $52
80105dfd:	6a 34                	push   $0x34
  jmp alltraps
80105dff:	e9 81 f9 ff ff       	jmp    80105785 <alltraps>

80105e04 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $53
80105e06:	6a 35                	push   $0x35
  jmp alltraps
80105e08:	e9 78 f9 ff ff       	jmp    80105785 <alltraps>

80105e0d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $54
80105e0f:	6a 36                	push   $0x36
  jmp alltraps
80105e11:	e9 6f f9 ff ff       	jmp    80105785 <alltraps>

80105e16 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $55
80105e18:	6a 37                	push   $0x37
  jmp alltraps
80105e1a:	e9 66 f9 ff ff       	jmp    80105785 <alltraps>

80105e1f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $56
80105e21:	6a 38                	push   $0x38
  jmp alltraps
80105e23:	e9 5d f9 ff ff       	jmp    80105785 <alltraps>

80105e28 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $57
80105e2a:	6a 39                	push   $0x39
  jmp alltraps
80105e2c:	e9 54 f9 ff ff       	jmp    80105785 <alltraps>

80105e31 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e31:	6a 00                	push   $0x0
  pushl $58
80105e33:	6a 3a                	push   $0x3a
  jmp alltraps
80105e35:	e9 4b f9 ff ff       	jmp    80105785 <alltraps>

80105e3a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $59
80105e3c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e3e:	e9 42 f9 ff ff       	jmp    80105785 <alltraps>

80105e43 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $60
80105e45:	6a 3c                	push   $0x3c
  jmp alltraps
80105e47:	e9 39 f9 ff ff       	jmp    80105785 <alltraps>

80105e4c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e4c:	6a 00                	push   $0x0
  pushl $61
80105e4e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e50:	e9 30 f9 ff ff       	jmp    80105785 <alltraps>

80105e55 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $62
80105e57:	6a 3e                	push   $0x3e
  jmp alltraps
80105e59:	e9 27 f9 ff ff       	jmp    80105785 <alltraps>

80105e5e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $63
80105e60:	6a 3f                	push   $0x3f
  jmp alltraps
80105e62:	e9 1e f9 ff ff       	jmp    80105785 <alltraps>

80105e67 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $64
80105e69:	6a 40                	push   $0x40
  jmp alltraps
80105e6b:	e9 15 f9 ff ff       	jmp    80105785 <alltraps>

80105e70 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $65
80105e72:	6a 41                	push   $0x41
  jmp alltraps
80105e74:	e9 0c f9 ff ff       	jmp    80105785 <alltraps>

80105e79 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $66
80105e7b:	6a 42                	push   $0x42
  jmp alltraps
80105e7d:	e9 03 f9 ff ff       	jmp    80105785 <alltraps>

80105e82 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $67
80105e84:	6a 43                	push   $0x43
  jmp alltraps
80105e86:	e9 fa f8 ff ff       	jmp    80105785 <alltraps>

80105e8b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $68
80105e8d:	6a 44                	push   $0x44
  jmp alltraps
80105e8f:	e9 f1 f8 ff ff       	jmp    80105785 <alltraps>

80105e94 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $69
80105e96:	6a 45                	push   $0x45
  jmp alltraps
80105e98:	e9 e8 f8 ff ff       	jmp    80105785 <alltraps>

80105e9d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $70
80105e9f:	6a 46                	push   $0x46
  jmp alltraps
80105ea1:	e9 df f8 ff ff       	jmp    80105785 <alltraps>

80105ea6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $71
80105ea8:	6a 47                	push   $0x47
  jmp alltraps
80105eaa:	e9 d6 f8 ff ff       	jmp    80105785 <alltraps>

80105eaf <vector72>:
.globl vector72
vector72:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $72
80105eb1:	6a 48                	push   $0x48
  jmp alltraps
80105eb3:	e9 cd f8 ff ff       	jmp    80105785 <alltraps>

80105eb8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105eb8:	6a 00                	push   $0x0
  pushl $73
80105eba:	6a 49                	push   $0x49
  jmp alltraps
80105ebc:	e9 c4 f8 ff ff       	jmp    80105785 <alltraps>

80105ec1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ec1:	6a 00                	push   $0x0
  pushl $74
80105ec3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ec5:	e9 bb f8 ff ff       	jmp    80105785 <alltraps>

80105eca <vector75>:
.globl vector75
vector75:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $75
80105ecc:	6a 4b                	push   $0x4b
  jmp alltraps
80105ece:	e9 b2 f8 ff ff       	jmp    80105785 <alltraps>

80105ed3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $76
80105ed5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ed7:	e9 a9 f8 ff ff       	jmp    80105785 <alltraps>

80105edc <vector77>:
.globl vector77
vector77:
  pushl $0
80105edc:	6a 00                	push   $0x0
  pushl $77
80105ede:	6a 4d                	push   $0x4d
  jmp alltraps
80105ee0:	e9 a0 f8 ff ff       	jmp    80105785 <alltraps>

80105ee5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ee5:	6a 00                	push   $0x0
  pushl $78
80105ee7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ee9:	e9 97 f8 ff ff       	jmp    80105785 <alltraps>

80105eee <vector79>:
.globl vector79
vector79:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $79
80105ef0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ef2:	e9 8e f8 ff ff       	jmp    80105785 <alltraps>

80105ef7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $80
80105ef9:	6a 50                	push   $0x50
  jmp alltraps
80105efb:	e9 85 f8 ff ff       	jmp    80105785 <alltraps>

80105f00 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f00:	6a 00                	push   $0x0
  pushl $81
80105f02:	6a 51                	push   $0x51
  jmp alltraps
80105f04:	e9 7c f8 ff ff       	jmp    80105785 <alltraps>

80105f09 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $82
80105f0b:	6a 52                	push   $0x52
  jmp alltraps
80105f0d:	e9 73 f8 ff ff       	jmp    80105785 <alltraps>

80105f12 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $83
80105f14:	6a 53                	push   $0x53
  jmp alltraps
80105f16:	e9 6a f8 ff ff       	jmp    80105785 <alltraps>

80105f1b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $84
80105f1d:	6a 54                	push   $0x54
  jmp alltraps
80105f1f:	e9 61 f8 ff ff       	jmp    80105785 <alltraps>

80105f24 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $85
80105f26:	6a 55                	push   $0x55
  jmp alltraps
80105f28:	e9 58 f8 ff ff       	jmp    80105785 <alltraps>

80105f2d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $86
80105f2f:	6a 56                	push   $0x56
  jmp alltraps
80105f31:	e9 4f f8 ff ff       	jmp    80105785 <alltraps>

80105f36 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $87
80105f38:	6a 57                	push   $0x57
  jmp alltraps
80105f3a:	e9 46 f8 ff ff       	jmp    80105785 <alltraps>

80105f3f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $88
80105f41:	6a 58                	push   $0x58
  jmp alltraps
80105f43:	e9 3d f8 ff ff       	jmp    80105785 <alltraps>

80105f48 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $89
80105f4a:	6a 59                	push   $0x59
  jmp alltraps
80105f4c:	e9 34 f8 ff ff       	jmp    80105785 <alltraps>

80105f51 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $90
80105f53:	6a 5a                	push   $0x5a
  jmp alltraps
80105f55:	e9 2b f8 ff ff       	jmp    80105785 <alltraps>

80105f5a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $91
80105f5c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f5e:	e9 22 f8 ff ff       	jmp    80105785 <alltraps>

80105f63 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $92
80105f65:	6a 5c                	push   $0x5c
  jmp alltraps
80105f67:	e9 19 f8 ff ff       	jmp    80105785 <alltraps>

80105f6c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $93
80105f6e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f70:	e9 10 f8 ff ff       	jmp    80105785 <alltraps>

80105f75 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $94
80105f77:	6a 5e                	push   $0x5e
  jmp alltraps
80105f79:	e9 07 f8 ff ff       	jmp    80105785 <alltraps>

80105f7e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $95
80105f80:	6a 5f                	push   $0x5f
  jmp alltraps
80105f82:	e9 fe f7 ff ff       	jmp    80105785 <alltraps>

80105f87 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $96
80105f89:	6a 60                	push   $0x60
  jmp alltraps
80105f8b:	e9 f5 f7 ff ff       	jmp    80105785 <alltraps>

80105f90 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $97
80105f92:	6a 61                	push   $0x61
  jmp alltraps
80105f94:	e9 ec f7 ff ff       	jmp    80105785 <alltraps>

80105f99 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $98
80105f9b:	6a 62                	push   $0x62
  jmp alltraps
80105f9d:	e9 e3 f7 ff ff       	jmp    80105785 <alltraps>

80105fa2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $99
80105fa4:	6a 63                	push   $0x63
  jmp alltraps
80105fa6:	e9 da f7 ff ff       	jmp    80105785 <alltraps>

80105fab <vector100>:
.globl vector100
vector100:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $100
80105fad:	6a 64                	push   $0x64
  jmp alltraps
80105faf:	e9 d1 f7 ff ff       	jmp    80105785 <alltraps>

80105fb4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $101
80105fb6:	6a 65                	push   $0x65
  jmp alltraps
80105fb8:	e9 c8 f7 ff ff       	jmp    80105785 <alltraps>

80105fbd <vector102>:
.globl vector102
vector102:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $102
80105fbf:	6a 66                	push   $0x66
  jmp alltraps
80105fc1:	e9 bf f7 ff ff       	jmp    80105785 <alltraps>

80105fc6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $103
80105fc8:	6a 67                	push   $0x67
  jmp alltraps
80105fca:	e9 b6 f7 ff ff       	jmp    80105785 <alltraps>

80105fcf <vector104>:
.globl vector104
vector104:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $104
80105fd1:	6a 68                	push   $0x68
  jmp alltraps
80105fd3:	e9 ad f7 ff ff       	jmp    80105785 <alltraps>

80105fd8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $105
80105fda:	6a 69                	push   $0x69
  jmp alltraps
80105fdc:	e9 a4 f7 ff ff       	jmp    80105785 <alltraps>

80105fe1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $106
80105fe3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fe5:	e9 9b f7 ff ff       	jmp    80105785 <alltraps>

80105fea <vector107>:
.globl vector107
vector107:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $107
80105fec:	6a 6b                	push   $0x6b
  jmp alltraps
80105fee:	e9 92 f7 ff ff       	jmp    80105785 <alltraps>

80105ff3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $108
80105ff5:	6a 6c                	push   $0x6c
  jmp alltraps
80105ff7:	e9 89 f7 ff ff       	jmp    80105785 <alltraps>

80105ffc <vector109>:
.globl vector109
vector109:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $109
80105ffe:	6a 6d                	push   $0x6d
  jmp alltraps
80106000:	e9 80 f7 ff ff       	jmp    80105785 <alltraps>

80106005 <vector110>:
.globl vector110
vector110:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $110
80106007:	6a 6e                	push   $0x6e
  jmp alltraps
80106009:	e9 77 f7 ff ff       	jmp    80105785 <alltraps>

8010600e <vector111>:
.globl vector111
vector111:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $111
80106010:	6a 6f                	push   $0x6f
  jmp alltraps
80106012:	e9 6e f7 ff ff       	jmp    80105785 <alltraps>

80106017 <vector112>:
.globl vector112
vector112:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $112
80106019:	6a 70                	push   $0x70
  jmp alltraps
8010601b:	e9 65 f7 ff ff       	jmp    80105785 <alltraps>

80106020 <vector113>:
.globl vector113
vector113:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $113
80106022:	6a 71                	push   $0x71
  jmp alltraps
80106024:	e9 5c f7 ff ff       	jmp    80105785 <alltraps>

80106029 <vector114>:
.globl vector114
vector114:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $114
8010602b:	6a 72                	push   $0x72
  jmp alltraps
8010602d:	e9 53 f7 ff ff       	jmp    80105785 <alltraps>

80106032 <vector115>:
.globl vector115
vector115:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $115
80106034:	6a 73                	push   $0x73
  jmp alltraps
80106036:	e9 4a f7 ff ff       	jmp    80105785 <alltraps>

8010603b <vector116>:
.globl vector116
vector116:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $116
8010603d:	6a 74                	push   $0x74
  jmp alltraps
8010603f:	e9 41 f7 ff ff       	jmp    80105785 <alltraps>

80106044 <vector117>:
.globl vector117
vector117:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $117
80106046:	6a 75                	push   $0x75
  jmp alltraps
80106048:	e9 38 f7 ff ff       	jmp    80105785 <alltraps>

8010604d <vector118>:
.globl vector118
vector118:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $118
8010604f:	6a 76                	push   $0x76
  jmp alltraps
80106051:	e9 2f f7 ff ff       	jmp    80105785 <alltraps>

80106056 <vector119>:
.globl vector119
vector119:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $119
80106058:	6a 77                	push   $0x77
  jmp alltraps
8010605a:	e9 26 f7 ff ff       	jmp    80105785 <alltraps>

8010605f <vector120>:
.globl vector120
vector120:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $120
80106061:	6a 78                	push   $0x78
  jmp alltraps
80106063:	e9 1d f7 ff ff       	jmp    80105785 <alltraps>

80106068 <vector121>:
.globl vector121
vector121:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $121
8010606a:	6a 79                	push   $0x79
  jmp alltraps
8010606c:	e9 14 f7 ff ff       	jmp    80105785 <alltraps>

80106071 <vector122>:
.globl vector122
vector122:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $122
80106073:	6a 7a                	push   $0x7a
  jmp alltraps
80106075:	e9 0b f7 ff ff       	jmp    80105785 <alltraps>

8010607a <vector123>:
.globl vector123
vector123:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $123
8010607c:	6a 7b                	push   $0x7b
  jmp alltraps
8010607e:	e9 02 f7 ff ff       	jmp    80105785 <alltraps>

80106083 <vector124>:
.globl vector124
vector124:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $124
80106085:	6a 7c                	push   $0x7c
  jmp alltraps
80106087:	e9 f9 f6 ff ff       	jmp    80105785 <alltraps>

8010608c <vector125>:
.globl vector125
vector125:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $125
8010608e:	6a 7d                	push   $0x7d
  jmp alltraps
80106090:	e9 f0 f6 ff ff       	jmp    80105785 <alltraps>

80106095 <vector126>:
.globl vector126
vector126:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $126
80106097:	6a 7e                	push   $0x7e
  jmp alltraps
80106099:	e9 e7 f6 ff ff       	jmp    80105785 <alltraps>

8010609e <vector127>:
.globl vector127
vector127:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $127
801060a0:	6a 7f                	push   $0x7f
  jmp alltraps
801060a2:	e9 de f6 ff ff       	jmp    80105785 <alltraps>

801060a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $128
801060a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801060ae:	e9 d2 f6 ff ff       	jmp    80105785 <alltraps>

801060b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $129
801060b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060ba:	e9 c6 f6 ff ff       	jmp    80105785 <alltraps>

801060bf <vector130>:
.globl vector130
vector130:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $130
801060c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060c6:	e9 ba f6 ff ff       	jmp    80105785 <alltraps>

801060cb <vector131>:
.globl vector131
vector131:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $131
801060cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060d2:	e9 ae f6 ff ff       	jmp    80105785 <alltraps>

801060d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $132
801060d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060de:	e9 a2 f6 ff ff       	jmp    80105785 <alltraps>

801060e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $133
801060e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060ea:	e9 96 f6 ff ff       	jmp    80105785 <alltraps>

801060ef <vector134>:
.globl vector134
vector134:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $134
801060f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060f6:	e9 8a f6 ff ff       	jmp    80105785 <alltraps>

801060fb <vector135>:
.globl vector135
vector135:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $135
801060fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106102:	e9 7e f6 ff ff       	jmp    80105785 <alltraps>

80106107 <vector136>:
.globl vector136
vector136:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $136
80106109:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010610e:	e9 72 f6 ff ff       	jmp    80105785 <alltraps>

80106113 <vector137>:
.globl vector137
vector137:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $137
80106115:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010611a:	e9 66 f6 ff ff       	jmp    80105785 <alltraps>

8010611f <vector138>:
.globl vector138
vector138:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $138
80106121:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106126:	e9 5a f6 ff ff       	jmp    80105785 <alltraps>

8010612b <vector139>:
.globl vector139
vector139:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $139
8010612d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106132:	e9 4e f6 ff ff       	jmp    80105785 <alltraps>

80106137 <vector140>:
.globl vector140
vector140:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $140
80106139:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010613e:	e9 42 f6 ff ff       	jmp    80105785 <alltraps>

80106143 <vector141>:
.globl vector141
vector141:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $141
80106145:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010614a:	e9 36 f6 ff ff       	jmp    80105785 <alltraps>

8010614f <vector142>:
.globl vector142
vector142:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $142
80106151:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106156:	e9 2a f6 ff ff       	jmp    80105785 <alltraps>

8010615b <vector143>:
.globl vector143
vector143:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $143
8010615d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106162:	e9 1e f6 ff ff       	jmp    80105785 <alltraps>

80106167 <vector144>:
.globl vector144
vector144:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $144
80106169:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010616e:	e9 12 f6 ff ff       	jmp    80105785 <alltraps>

80106173 <vector145>:
.globl vector145
vector145:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $145
80106175:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010617a:	e9 06 f6 ff ff       	jmp    80105785 <alltraps>

8010617f <vector146>:
.globl vector146
vector146:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $146
80106181:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106186:	e9 fa f5 ff ff       	jmp    80105785 <alltraps>

8010618b <vector147>:
.globl vector147
vector147:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $147
8010618d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106192:	e9 ee f5 ff ff       	jmp    80105785 <alltraps>

80106197 <vector148>:
.globl vector148
vector148:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $148
80106199:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010619e:	e9 e2 f5 ff ff       	jmp    80105785 <alltraps>

801061a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $149
801061a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801061aa:	e9 d6 f5 ff ff       	jmp    80105785 <alltraps>

801061af <vector150>:
.globl vector150
vector150:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $150
801061b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061b6:	e9 ca f5 ff ff       	jmp    80105785 <alltraps>

801061bb <vector151>:
.globl vector151
vector151:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $151
801061bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061c2:	e9 be f5 ff ff       	jmp    80105785 <alltraps>

801061c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $152
801061c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061ce:	e9 b2 f5 ff ff       	jmp    80105785 <alltraps>

801061d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $153
801061d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061da:	e9 a6 f5 ff ff       	jmp    80105785 <alltraps>

801061df <vector154>:
.globl vector154
vector154:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $154
801061e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061e6:	e9 9a f5 ff ff       	jmp    80105785 <alltraps>

801061eb <vector155>:
.globl vector155
vector155:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $155
801061ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061f2:	e9 8e f5 ff ff       	jmp    80105785 <alltraps>

801061f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $156
801061f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061fe:	e9 82 f5 ff ff       	jmp    80105785 <alltraps>

80106203 <vector157>:
.globl vector157
vector157:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $157
80106205:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010620a:	e9 76 f5 ff ff       	jmp    80105785 <alltraps>

8010620f <vector158>:
.globl vector158
vector158:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $158
80106211:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106216:	e9 6a f5 ff ff       	jmp    80105785 <alltraps>

8010621b <vector159>:
.globl vector159
vector159:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $159
8010621d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106222:	e9 5e f5 ff ff       	jmp    80105785 <alltraps>

80106227 <vector160>:
.globl vector160
vector160:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $160
80106229:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010622e:	e9 52 f5 ff ff       	jmp    80105785 <alltraps>

80106233 <vector161>:
.globl vector161
vector161:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $161
80106235:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010623a:	e9 46 f5 ff ff       	jmp    80105785 <alltraps>

8010623f <vector162>:
.globl vector162
vector162:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $162
80106241:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106246:	e9 3a f5 ff ff       	jmp    80105785 <alltraps>

8010624b <vector163>:
.globl vector163
vector163:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $163
8010624d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106252:	e9 2e f5 ff ff       	jmp    80105785 <alltraps>

80106257 <vector164>:
.globl vector164
vector164:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $164
80106259:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010625e:	e9 22 f5 ff ff       	jmp    80105785 <alltraps>

80106263 <vector165>:
.globl vector165
vector165:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $165
80106265:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010626a:	e9 16 f5 ff ff       	jmp    80105785 <alltraps>

8010626f <vector166>:
.globl vector166
vector166:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $166
80106271:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106276:	e9 0a f5 ff ff       	jmp    80105785 <alltraps>

8010627b <vector167>:
.globl vector167
vector167:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $167
8010627d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106282:	e9 fe f4 ff ff       	jmp    80105785 <alltraps>

80106287 <vector168>:
.globl vector168
vector168:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $168
80106289:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010628e:	e9 f2 f4 ff ff       	jmp    80105785 <alltraps>

80106293 <vector169>:
.globl vector169
vector169:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $169
80106295:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010629a:	e9 e6 f4 ff ff       	jmp    80105785 <alltraps>

8010629f <vector170>:
.globl vector170
vector170:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $170
801062a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801062a6:	e9 da f4 ff ff       	jmp    80105785 <alltraps>

801062ab <vector171>:
.globl vector171
vector171:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $171
801062ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062b2:	e9 ce f4 ff ff       	jmp    80105785 <alltraps>

801062b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $172
801062b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062be:	e9 c2 f4 ff ff       	jmp    80105785 <alltraps>

801062c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $173
801062c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062ca:	e9 b6 f4 ff ff       	jmp    80105785 <alltraps>

801062cf <vector174>:
.globl vector174
vector174:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $174
801062d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062d6:	e9 aa f4 ff ff       	jmp    80105785 <alltraps>

801062db <vector175>:
.globl vector175
vector175:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $175
801062dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062e2:	e9 9e f4 ff ff       	jmp    80105785 <alltraps>

801062e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $176
801062e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062ee:	e9 92 f4 ff ff       	jmp    80105785 <alltraps>

801062f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $177
801062f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062fa:	e9 86 f4 ff ff       	jmp    80105785 <alltraps>

801062ff <vector178>:
.globl vector178
vector178:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $178
80106301:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106306:	e9 7a f4 ff ff       	jmp    80105785 <alltraps>

8010630b <vector179>:
.globl vector179
vector179:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $179
8010630d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106312:	e9 6e f4 ff ff       	jmp    80105785 <alltraps>

80106317 <vector180>:
.globl vector180
vector180:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $180
80106319:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010631e:	e9 62 f4 ff ff       	jmp    80105785 <alltraps>

80106323 <vector181>:
.globl vector181
vector181:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $181
80106325:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010632a:	e9 56 f4 ff ff       	jmp    80105785 <alltraps>

8010632f <vector182>:
.globl vector182
vector182:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $182
80106331:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106336:	e9 4a f4 ff ff       	jmp    80105785 <alltraps>

8010633b <vector183>:
.globl vector183
vector183:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $183
8010633d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106342:	e9 3e f4 ff ff       	jmp    80105785 <alltraps>

80106347 <vector184>:
.globl vector184
vector184:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $184
80106349:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010634e:	e9 32 f4 ff ff       	jmp    80105785 <alltraps>

80106353 <vector185>:
.globl vector185
vector185:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $185
80106355:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010635a:	e9 26 f4 ff ff       	jmp    80105785 <alltraps>

8010635f <vector186>:
.globl vector186
vector186:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $186
80106361:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106366:	e9 1a f4 ff ff       	jmp    80105785 <alltraps>

8010636b <vector187>:
.globl vector187
vector187:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $187
8010636d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106372:	e9 0e f4 ff ff       	jmp    80105785 <alltraps>

80106377 <vector188>:
.globl vector188
vector188:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $188
80106379:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010637e:	e9 02 f4 ff ff       	jmp    80105785 <alltraps>

80106383 <vector189>:
.globl vector189
vector189:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $189
80106385:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010638a:	e9 f6 f3 ff ff       	jmp    80105785 <alltraps>

8010638f <vector190>:
.globl vector190
vector190:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $190
80106391:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106396:	e9 ea f3 ff ff       	jmp    80105785 <alltraps>

8010639b <vector191>:
.globl vector191
vector191:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $191
8010639d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801063a2:	e9 de f3 ff ff       	jmp    80105785 <alltraps>

801063a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $192
801063a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801063ae:	e9 d2 f3 ff ff       	jmp    80105785 <alltraps>

801063b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $193
801063b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063ba:	e9 c6 f3 ff ff       	jmp    80105785 <alltraps>

801063bf <vector194>:
.globl vector194
vector194:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $194
801063c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063c6:	e9 ba f3 ff ff       	jmp    80105785 <alltraps>

801063cb <vector195>:
.globl vector195
vector195:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $195
801063cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063d2:	e9 ae f3 ff ff       	jmp    80105785 <alltraps>

801063d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $196
801063d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063de:	e9 a2 f3 ff ff       	jmp    80105785 <alltraps>

801063e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $197
801063e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063ea:	e9 96 f3 ff ff       	jmp    80105785 <alltraps>

801063ef <vector198>:
.globl vector198
vector198:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $198
801063f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063f6:	e9 8a f3 ff ff       	jmp    80105785 <alltraps>

801063fb <vector199>:
.globl vector199
vector199:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $199
801063fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106402:	e9 7e f3 ff ff       	jmp    80105785 <alltraps>

80106407 <vector200>:
.globl vector200
vector200:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $200
80106409:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010640e:	e9 72 f3 ff ff       	jmp    80105785 <alltraps>

80106413 <vector201>:
.globl vector201
vector201:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $201
80106415:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010641a:	e9 66 f3 ff ff       	jmp    80105785 <alltraps>

8010641f <vector202>:
.globl vector202
vector202:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $202
80106421:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106426:	e9 5a f3 ff ff       	jmp    80105785 <alltraps>

8010642b <vector203>:
.globl vector203
vector203:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $203
8010642d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106432:	e9 4e f3 ff ff       	jmp    80105785 <alltraps>

80106437 <vector204>:
.globl vector204
vector204:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $204
80106439:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010643e:	e9 42 f3 ff ff       	jmp    80105785 <alltraps>

80106443 <vector205>:
.globl vector205
vector205:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $205
80106445:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010644a:	e9 36 f3 ff ff       	jmp    80105785 <alltraps>

8010644f <vector206>:
.globl vector206
vector206:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $206
80106451:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106456:	e9 2a f3 ff ff       	jmp    80105785 <alltraps>

8010645b <vector207>:
.globl vector207
vector207:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $207
8010645d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106462:	e9 1e f3 ff ff       	jmp    80105785 <alltraps>

80106467 <vector208>:
.globl vector208
vector208:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $208
80106469:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010646e:	e9 12 f3 ff ff       	jmp    80105785 <alltraps>

80106473 <vector209>:
.globl vector209
vector209:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $209
80106475:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010647a:	e9 06 f3 ff ff       	jmp    80105785 <alltraps>

8010647f <vector210>:
.globl vector210
vector210:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $210
80106481:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106486:	e9 fa f2 ff ff       	jmp    80105785 <alltraps>

8010648b <vector211>:
.globl vector211
vector211:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $211
8010648d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106492:	e9 ee f2 ff ff       	jmp    80105785 <alltraps>

80106497 <vector212>:
.globl vector212
vector212:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $212
80106499:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010649e:	e9 e2 f2 ff ff       	jmp    80105785 <alltraps>

801064a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $213
801064a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801064aa:	e9 d6 f2 ff ff       	jmp    80105785 <alltraps>

801064af <vector214>:
.globl vector214
vector214:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $214
801064b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064b6:	e9 ca f2 ff ff       	jmp    80105785 <alltraps>

801064bb <vector215>:
.globl vector215
vector215:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $215
801064bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064c2:	e9 be f2 ff ff       	jmp    80105785 <alltraps>

801064c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $216
801064c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064ce:	e9 b2 f2 ff ff       	jmp    80105785 <alltraps>

801064d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $217
801064d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064da:	e9 a6 f2 ff ff       	jmp    80105785 <alltraps>

801064df <vector218>:
.globl vector218
vector218:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $218
801064e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064e6:	e9 9a f2 ff ff       	jmp    80105785 <alltraps>

801064eb <vector219>:
.globl vector219
vector219:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $219
801064ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064f2:	e9 8e f2 ff ff       	jmp    80105785 <alltraps>

801064f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $220
801064f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064fe:	e9 82 f2 ff ff       	jmp    80105785 <alltraps>

80106503 <vector221>:
.globl vector221
vector221:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $221
80106505:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010650a:	e9 76 f2 ff ff       	jmp    80105785 <alltraps>

8010650f <vector222>:
.globl vector222
vector222:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $222
80106511:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106516:	e9 6a f2 ff ff       	jmp    80105785 <alltraps>

8010651b <vector223>:
.globl vector223
vector223:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $223
8010651d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106522:	e9 5e f2 ff ff       	jmp    80105785 <alltraps>

80106527 <vector224>:
.globl vector224
vector224:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $224
80106529:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010652e:	e9 52 f2 ff ff       	jmp    80105785 <alltraps>

80106533 <vector225>:
.globl vector225
vector225:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $225
80106535:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010653a:	e9 46 f2 ff ff       	jmp    80105785 <alltraps>

8010653f <vector226>:
.globl vector226
vector226:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $226
80106541:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106546:	e9 3a f2 ff ff       	jmp    80105785 <alltraps>

8010654b <vector227>:
.globl vector227
vector227:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $227
8010654d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106552:	e9 2e f2 ff ff       	jmp    80105785 <alltraps>

80106557 <vector228>:
.globl vector228
vector228:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $228
80106559:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010655e:	e9 22 f2 ff ff       	jmp    80105785 <alltraps>

80106563 <vector229>:
.globl vector229
vector229:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $229
80106565:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010656a:	e9 16 f2 ff ff       	jmp    80105785 <alltraps>

8010656f <vector230>:
.globl vector230
vector230:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $230
80106571:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106576:	e9 0a f2 ff ff       	jmp    80105785 <alltraps>

8010657b <vector231>:
.globl vector231
vector231:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $231
8010657d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106582:	e9 fe f1 ff ff       	jmp    80105785 <alltraps>

80106587 <vector232>:
.globl vector232
vector232:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $232
80106589:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010658e:	e9 f2 f1 ff ff       	jmp    80105785 <alltraps>

80106593 <vector233>:
.globl vector233
vector233:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $233
80106595:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010659a:	e9 e6 f1 ff ff       	jmp    80105785 <alltraps>

8010659f <vector234>:
.globl vector234
vector234:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $234
801065a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801065a6:	e9 da f1 ff ff       	jmp    80105785 <alltraps>

801065ab <vector235>:
.globl vector235
vector235:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $235
801065ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065b2:	e9 ce f1 ff ff       	jmp    80105785 <alltraps>

801065b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $236
801065b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065be:	e9 c2 f1 ff ff       	jmp    80105785 <alltraps>

801065c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $237
801065c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065ca:	e9 b6 f1 ff ff       	jmp    80105785 <alltraps>

801065cf <vector238>:
.globl vector238
vector238:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $238
801065d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065d6:	e9 aa f1 ff ff       	jmp    80105785 <alltraps>

801065db <vector239>:
.globl vector239
vector239:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $239
801065dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065e2:	e9 9e f1 ff ff       	jmp    80105785 <alltraps>

801065e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $240
801065e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065ee:	e9 92 f1 ff ff       	jmp    80105785 <alltraps>

801065f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $241
801065f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065fa:	e9 86 f1 ff ff       	jmp    80105785 <alltraps>

801065ff <vector242>:
.globl vector242
vector242:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $242
80106601:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106606:	e9 7a f1 ff ff       	jmp    80105785 <alltraps>

8010660b <vector243>:
.globl vector243
vector243:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $243
8010660d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106612:	e9 6e f1 ff ff       	jmp    80105785 <alltraps>

80106617 <vector244>:
.globl vector244
vector244:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $244
80106619:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010661e:	e9 62 f1 ff ff       	jmp    80105785 <alltraps>

80106623 <vector245>:
.globl vector245
vector245:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $245
80106625:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010662a:	e9 56 f1 ff ff       	jmp    80105785 <alltraps>

8010662f <vector246>:
.globl vector246
vector246:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $246
80106631:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106636:	e9 4a f1 ff ff       	jmp    80105785 <alltraps>

8010663b <vector247>:
.globl vector247
vector247:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $247
8010663d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106642:	e9 3e f1 ff ff       	jmp    80105785 <alltraps>

80106647 <vector248>:
.globl vector248
vector248:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $248
80106649:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010664e:	e9 32 f1 ff ff       	jmp    80105785 <alltraps>

80106653 <vector249>:
.globl vector249
vector249:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $249
80106655:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010665a:	e9 26 f1 ff ff       	jmp    80105785 <alltraps>

8010665f <vector250>:
.globl vector250
vector250:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $250
80106661:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106666:	e9 1a f1 ff ff       	jmp    80105785 <alltraps>

8010666b <vector251>:
.globl vector251
vector251:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $251
8010666d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106672:	e9 0e f1 ff ff       	jmp    80105785 <alltraps>

80106677 <vector252>:
.globl vector252
vector252:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $252
80106679:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010667e:	e9 02 f1 ff ff       	jmp    80105785 <alltraps>

80106683 <vector253>:
.globl vector253
vector253:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $253
80106685:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010668a:	e9 f6 f0 ff ff       	jmp    80105785 <alltraps>

8010668f <vector254>:
.globl vector254
vector254:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $254
80106691:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106696:	e9 ea f0 ff ff       	jmp    80105785 <alltraps>

8010669b <vector255>:
.globl vector255
vector255:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $255
8010669d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801066a2:	e9 de f0 ff ff       	jmp    80105785 <alltraps>
801066a7:	66 90                	xchg   %ax,%ax
801066a9:	66 90                	xchg   %ax,%ax
801066ab:	66 90                	xchg   %ax,%ax
801066ad:	66 90                	xchg   %ax,%ax
801066af:	90                   	nop

801066b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	56                   	push   %esi
801066b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066b7:	c1 ea 16             	shr    $0x16,%edx
{
801066ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801066bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801066be:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801066c1:	8b 1f                	mov    (%edi),%ebx
801066c3:	f6 c3 01             	test   $0x1,%bl
801066c6:	74 28                	je     801066f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801066ce:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066d4:	89 f0                	mov    %esi,%eax
}
801066d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801066d9:	c1 e8 0a             	shr    $0xa,%eax
801066dc:	25 fc 0f 00 00       	and    $0xffc,%eax
801066e1:	01 d8                	add    %ebx,%eax
}
801066e3:	5b                   	pop    %ebx
801066e4:	5e                   	pop    %esi
801066e5:	5f                   	pop    %edi
801066e6:	5d                   	pop    %ebp
801066e7:	c3                   	ret    
801066e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ef:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066f0:	85 c9                	test   %ecx,%ecx
801066f2:	74 2c                	je     80106720 <walkpgdir+0x70>
801066f4:	e8 97 be ff ff       	call   80102590 <kalloc>
801066f9:	89 c3                	mov    %eax,%ebx
801066fb:	85 c0                	test   %eax,%eax
801066fd:	74 21                	je     80106720 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801066ff:	83 ec 04             	sub    $0x4,%esp
80106702:	68 00 10 00 00       	push   $0x1000
80106707:	6a 00                	push   $0x0
80106709:	50                   	push   %eax
8010670a:	e8 e1 de ff ff       	call   801045f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010670f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106715:	83 c4 10             	add    $0x10,%esp
80106718:	83 c8 07             	or     $0x7,%eax
8010671b:	89 07                	mov    %eax,(%edi)
8010671d:	eb b5                	jmp    801066d4 <walkpgdir+0x24>
8010671f:	90                   	nop
}
80106720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106723:	31 c0                	xor    %eax,%eax
}
80106725:	5b                   	pop    %ebx
80106726:	5e                   	pop    %esi
80106727:	5f                   	pop    %edi
80106728:	5d                   	pop    %ebp
80106729:	c3                   	ret    
8010672a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106730 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106736:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010673a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010673b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106740:	89 d6                	mov    %edx,%esi
{
80106742:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106743:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106749:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010674c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010674f:	8b 45 08             	mov    0x8(%ebp),%eax
80106752:	29 f0                	sub    %esi,%eax
80106754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106757:	eb 1f                	jmp    80106778 <mappages+0x48>
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106760:	f6 00 01             	testb  $0x1,(%eax)
80106763:	75 45                	jne    801067aa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106765:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106768:	83 cb 01             	or     $0x1,%ebx
8010676b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010676d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106770:	74 2e                	je     801067a0 <mappages+0x70>
      break;
    a += PGSIZE;
80106772:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010677b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106780:	89 f2                	mov    %esi,%edx
80106782:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106785:	89 f8                	mov    %edi,%eax
80106787:	e8 24 ff ff ff       	call   801066b0 <walkpgdir>
8010678c:	85 c0                	test   %eax,%eax
8010678e:	75 d0                	jne    80106760 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106790:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106793:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106798:	5b                   	pop    %ebx
80106799:	5e                   	pop    %esi
8010679a:	5f                   	pop    %edi
8010679b:	5d                   	pop    %ebp
8010679c:	c3                   	ret    
8010679d:	8d 76 00             	lea    0x0(%esi),%esi
801067a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801067a3:	31 c0                	xor    %eax,%eax
}
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5f                   	pop    %edi
801067a8:	5d                   	pop    %ebp
801067a9:	c3                   	ret    
      panic("remap");
801067aa:	83 ec 0c             	sub    $0xc,%esp
801067ad:	68 d0 78 10 80       	push   $0x801078d0
801067b2:	e8 c9 9b ff ff       	call   80100380 <panic>
801067b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067be:	66 90                	xchg   %ax,%ax

801067c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	56                   	push   %esi
801067c5:	89 c6                	mov    %eax,%esi
801067c7:	53                   	push   %ebx
801067c8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067ca:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801067d0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067d6:	83 ec 1c             	sub    $0x1c,%esp
801067d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801067dc:	39 da                	cmp    %ebx,%edx
801067de:	73 5b                	jae    8010683b <deallocuvm.part.0+0x7b>
801067e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801067e3:	89 d7                	mov    %edx,%edi
801067e5:	eb 14                	jmp    801067fb <deallocuvm.part.0+0x3b>
801067e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ee:	66 90                	xchg   %ax,%ax
801067f0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801067f6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801067f9:	76 40                	jbe    8010683b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067fb:	31 c9                	xor    %ecx,%ecx
801067fd:	89 fa                	mov    %edi,%edx
801067ff:	89 f0                	mov    %esi,%eax
80106801:	e8 aa fe ff ff       	call   801066b0 <walkpgdir>
80106806:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106808:	85 c0                	test   %eax,%eax
8010680a:	74 44                	je     80106850 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010680c:	8b 00                	mov    (%eax),%eax
8010680e:	a8 01                	test   $0x1,%al
80106810:	74 de                	je     801067f0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106812:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106817:	74 47                	je     80106860 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106819:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010681c:	05 00 00 00 80       	add    $0x80000000,%eax
80106821:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106827:	50                   	push   %eax
80106828:	e8 a3 bb ff ff       	call   801023d0 <kfree>
      *pte = 0;
8010682d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106833:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106836:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106839:	77 c0                	ja     801067fb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010683b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010683e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106841:	5b                   	pop    %ebx
80106842:	5e                   	pop    %esi
80106843:	5f                   	pop    %edi
80106844:	5d                   	pop    %ebp
80106845:	c3                   	ret    
80106846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010684d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106850:	89 fa                	mov    %edi,%edx
80106852:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106858:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010685e:	eb 96                	jmp    801067f6 <deallocuvm.part.0+0x36>
        panic("kfree");
80106860:	83 ec 0c             	sub    $0xc,%esp
80106863:	68 26 72 10 80       	push   $0x80107226
80106868:	e8 13 9b ff ff       	call   80100380 <panic>
8010686d:	8d 76 00             	lea    0x0(%esi),%esi

80106870 <seginit>:
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106876:	e8 c5 cf ff ff       	call   80103840 <cpuid>
  pd[0] = size-1;
8010687b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106880:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106886:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010688a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106891:	ff 00 00 
80106894:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010689b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010689e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801068a5:	ff 00 00 
801068a8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801068af:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068b2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801068b9:	ff 00 00 
801068bc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801068c3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068c6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801068cd:	ff 00 00 
801068d0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801068d7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801068da:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
801068df:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068e3:	c1 e8 10             	shr    $0x10,%eax
801068e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801068ea:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068ed:	0f 01 10             	lgdtl  (%eax)
}
801068f0:	c9                   	leave  
801068f1:	c3                   	ret    
801068f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106900 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106900:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106905:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010690a:	0f 22 d8             	mov    %eax,%cr3
}
8010690d:	c3                   	ret    
8010690e:	66 90                	xchg   %ax,%ax

80106910 <switchuvm>:
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010691c:	85 f6                	test   %esi,%esi
8010691e:	0f 84 cb 00 00 00    	je     801069ef <switchuvm+0xdf>
  if(p->kstack == 0)
80106924:	8b 46 08             	mov    0x8(%esi),%eax
80106927:	85 c0                	test   %eax,%eax
80106929:	0f 84 da 00 00 00    	je     80106a09 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010692f:	8b 46 04             	mov    0x4(%esi),%eax
80106932:	85 c0                	test   %eax,%eax
80106934:	0f 84 c2 00 00 00    	je     801069fc <switchuvm+0xec>
  pushcli();
8010693a:	e8 f1 da ff ff       	call   80104430 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010693f:	e8 8c ce ff ff       	call   801037d0 <mycpu>
80106944:	89 c3                	mov    %eax,%ebx
80106946:	e8 85 ce ff ff       	call   801037d0 <mycpu>
8010694b:	89 c7                	mov    %eax,%edi
8010694d:	e8 7e ce ff ff       	call   801037d0 <mycpu>
80106952:	83 c7 08             	add    $0x8,%edi
80106955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106958:	e8 73 ce ff ff       	call   801037d0 <mycpu>
8010695d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106960:	ba 67 00 00 00       	mov    $0x67,%edx
80106965:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010696c:	83 c0 08             	add    $0x8,%eax
8010696f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106976:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010697b:	83 c1 08             	add    $0x8,%ecx
8010697e:	c1 e8 18             	shr    $0x18,%eax
80106981:	c1 e9 10             	shr    $0x10,%ecx
80106984:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010698a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106990:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106995:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010699c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801069a1:	e8 2a ce ff ff       	call   801037d0 <mycpu>
801069a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069ad:	e8 1e ce ff ff       	call   801037d0 <mycpu>
801069b2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069b6:	8b 5e 08             	mov    0x8(%esi),%ebx
801069b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069bf:	e8 0c ce ff ff       	call   801037d0 <mycpu>
801069c4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069c7:	e8 04 ce ff ff       	call   801037d0 <mycpu>
801069cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801069d0:	b8 28 00 00 00       	mov    $0x28,%eax
801069d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801069d8:	8b 46 04             	mov    0x4(%esi),%eax
801069db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069e0:	0f 22 d8             	mov    %eax,%cr3
}
801069e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e6:	5b                   	pop    %ebx
801069e7:	5e                   	pop    %esi
801069e8:	5f                   	pop    %edi
801069e9:	5d                   	pop    %ebp
  popcli();
801069ea:	e9 51 db ff ff       	jmp    80104540 <popcli>
    panic("switchuvm: no process");
801069ef:	83 ec 0c             	sub    $0xc,%esp
801069f2:	68 d6 78 10 80       	push   $0x801078d6
801069f7:	e8 84 99 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801069fc:	83 ec 0c             	sub    $0xc,%esp
801069ff:	68 01 79 10 80       	push   $0x80107901
80106a04:	e8 77 99 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106a09:	83 ec 0c             	sub    $0xc,%esp
80106a0c:	68 ec 78 10 80       	push   $0x801078ec
80106a11:	e8 6a 99 ff ff       	call   80100380 <panic>
80106a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi

80106a20 <inituvm>:
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 1c             	sub    $0x1c,%esp
80106a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a2f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a3b:	77 4b                	ja     80106a88 <inituvm+0x68>
  mem = kalloc();
80106a3d:	e8 4e bb ff ff       	call   80102590 <kalloc>
  memset(mem, 0, PGSIZE);
80106a42:	83 ec 04             	sub    $0x4,%esp
80106a45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106a4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a4c:	6a 00                	push   $0x0
80106a4e:	50                   	push   %eax
80106a4f:	e8 9c db ff ff       	call   801045f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a54:	58                   	pop    %eax
80106a55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a5b:	5a                   	pop    %edx
80106a5c:	6a 06                	push   $0x6
80106a5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a63:	31 d2                	xor    %edx,%edx
80106a65:	50                   	push   %eax
80106a66:	89 f8                	mov    %edi,%eax
80106a68:	e8 c3 fc ff ff       	call   80106730 <mappages>
  memmove(mem, init, sz);
80106a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a70:	89 75 10             	mov    %esi,0x10(%ebp)
80106a73:	83 c4 10             	add    $0x10,%esp
80106a76:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106a79:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a7f:	5b                   	pop    %ebx
80106a80:	5e                   	pop    %esi
80106a81:	5f                   	pop    %edi
80106a82:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a83:	e9 08 dc ff ff       	jmp    80104690 <memmove>
    panic("inituvm: more than a page");
80106a88:	83 ec 0c             	sub    $0xc,%esp
80106a8b:	68 15 79 10 80       	push   $0x80107915
80106a90:	e8 eb 98 ff ff       	call   80100380 <panic>
80106a95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <loaduvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106aaf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ab4:	0f 85 8d 00 00 00    	jne    80106b47 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106aba:	01 f0                	add    %esi,%eax
80106abc:	89 f3                	mov    %esi,%ebx
80106abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ac1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ac4:	01 f0                	add    %esi,%eax
80106ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ac9:	85 f6                	test   %esi,%esi
80106acb:	75 11                	jne    80106ade <loaduvm+0x3e>
80106acd:	eb 61                	jmp    80106b30 <loaduvm+0x90>
80106acf:	90                   	nop
80106ad0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ad6:	89 f0                	mov    %esi,%eax
80106ad8:	29 d8                	sub    %ebx,%eax
80106ada:	39 c6                	cmp    %eax,%esi
80106adc:	76 52                	jbe    80106b30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ade:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae4:	31 c9                	xor    %ecx,%ecx
80106ae6:	29 da                	sub    %ebx,%edx
80106ae8:	e8 c3 fb ff ff       	call   801066b0 <walkpgdir>
80106aed:	85 c0                	test   %eax,%eax
80106aef:	74 49                	je     80106b3a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106af1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106af6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106afb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b00:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106b06:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b09:	29 d9                	sub    %ebx,%ecx
80106b0b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b10:	57                   	push   %edi
80106b11:	51                   	push   %ecx
80106b12:	50                   	push   %eax
80106b13:	ff 75 10             	pushl  0x10(%ebp)
80106b16:	e8 d5 ae ff ff       	call   801019f0 <readi>
80106b1b:	83 c4 10             	add    $0x10,%esp
80106b1e:	39 f8                	cmp    %edi,%eax
80106b20:	74 ae                	je     80106ad0 <loaduvm+0x30>
}
80106b22:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b2a:	5b                   	pop    %ebx
80106b2b:	5e                   	pop    %esi
80106b2c:	5f                   	pop    %edi
80106b2d:	5d                   	pop    %ebp
80106b2e:	c3                   	ret    
80106b2f:	90                   	nop
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	68 2f 79 10 80       	push   $0x8010792f
80106b42:	e8 39 98 ff ff       	call   80100380 <panic>
    panic("loaduvm: addr must be page aligned");
80106b47:	83 ec 0c             	sub    $0xc,%esp
80106b4a:	68 d0 79 10 80       	push   $0x801079d0
80106b4f:	e8 2c 98 ff ff       	call   80100380 <panic>
80106b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b5f:	90                   	nop

80106b60 <allocuvm>:
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b69:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106b6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106b6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b72:	85 c0                	test   %eax,%eax
80106b74:	0f 88 b6 00 00 00    	js     80106c30 <allocuvm+0xd0>
  if(newsz < oldsz)
80106b7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106b80:	0f 82 9a 00 00 00    	jb     80106c20 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106b86:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106b8c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106b92:	39 75 10             	cmp    %esi,0x10(%ebp)
80106b95:	77 44                	ja     80106bdb <allocuvm+0x7b>
80106b97:	e9 87 00 00 00       	jmp    80106c23 <allocuvm+0xc3>
80106b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ba0:	83 ec 04             	sub    $0x4,%esp
80106ba3:	68 00 10 00 00       	push   $0x1000
80106ba8:	6a 00                	push   $0x0
80106baa:	50                   	push   %eax
80106bab:	e8 40 da ff ff       	call   801045f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106bb0:	58                   	pop    %eax
80106bb1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bb7:	5a                   	pop    %edx
80106bb8:	6a 06                	push   $0x6
80106bba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bbf:	89 f2                	mov    %esi,%edx
80106bc1:	50                   	push   %eax
80106bc2:	89 f8                	mov    %edi,%eax
80106bc4:	e8 67 fb ff ff       	call   80106730 <mappages>
80106bc9:	83 c4 10             	add    $0x10,%esp
80106bcc:	85 c0                	test   %eax,%eax
80106bce:	78 78                	js     80106c48 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106bd0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106bd6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106bd9:	76 48                	jbe    80106c23 <allocuvm+0xc3>
    mem = kalloc();
80106bdb:	e8 b0 b9 ff ff       	call   80102590 <kalloc>
80106be0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106be2:	85 c0                	test   %eax,%eax
80106be4:	75 ba                	jne    80106ba0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106be6:	83 ec 0c             	sub    $0xc,%esp
80106be9:	68 4d 79 10 80       	push   $0x8010794d
80106bee:	e8 ad 9a ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bf6:	83 c4 10             	add    $0x10,%esp
80106bf9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bfc:	74 32                	je     80106c30 <allocuvm+0xd0>
80106bfe:	8b 55 10             	mov    0x10(%ebp),%edx
80106c01:	89 c1                	mov    %eax,%ecx
80106c03:	89 f8                	mov    %edi,%eax
80106c05:	e8 b6 fb ff ff       	call   801067c0 <deallocuvm.part.0>
      return 0;
80106c0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c17:	5b                   	pop    %ebx
80106c18:	5e                   	pop    %esi
80106c19:	5f                   	pop    %edi
80106c1a:	5d                   	pop    %ebp
80106c1b:	c3                   	ret    
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106c20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c29:	5b                   	pop    %ebx
80106c2a:	5e                   	pop    %esi
80106c2b:	5f                   	pop    %edi
80106c2c:	5d                   	pop    %ebp
80106c2d:	c3                   	ret    
80106c2e:	66 90                	xchg   %ax,%ax
    return 0;
80106c30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c3d:	5b                   	pop    %ebx
80106c3e:	5e                   	pop    %esi
80106c3f:	5f                   	pop    %edi
80106c40:	5d                   	pop    %ebp
80106c41:	c3                   	ret    
80106c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106c48:	83 ec 0c             	sub    $0xc,%esp
80106c4b:	68 65 79 10 80       	push   $0x80107965
80106c50:	e8 4b 9a ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c58:	83 c4 10             	add    $0x10,%esp
80106c5b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c5e:	74 0c                	je     80106c6c <allocuvm+0x10c>
80106c60:	8b 55 10             	mov    0x10(%ebp),%edx
80106c63:	89 c1                	mov    %eax,%ecx
80106c65:	89 f8                	mov    %edi,%eax
80106c67:	e8 54 fb ff ff       	call   801067c0 <deallocuvm.part.0>
      kfree(mem);
80106c6c:	83 ec 0c             	sub    $0xc,%esp
80106c6f:	53                   	push   %ebx
80106c70:	e8 5b b7 ff ff       	call   801023d0 <kfree>
      return 0;
80106c75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106c7c:	83 c4 10             	add    $0x10,%esp
}
80106c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
80106c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c90 <deallocuvm>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c99:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c9c:	39 d1                	cmp    %edx,%ecx
80106c9e:	73 10                	jae    80106cb0 <deallocuvm+0x20>
}
80106ca0:	5d                   	pop    %ebp
80106ca1:	e9 1a fb ff ff       	jmp    801067c0 <deallocuvm.part.0>
80106ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cad:	8d 76 00             	lea    0x0(%esi),%esi
80106cb0:	89 d0                	mov    %edx,%eax
80106cb2:	5d                   	pop    %ebp
80106cb3:	c3                   	ret    
80106cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cbf:	90                   	nop

80106cc0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ccc:	85 f6                	test   %esi,%esi
80106cce:	74 59                	je     80106d29 <freevm+0x69>
  if(newsz >= oldsz)
80106cd0:	31 c9                	xor    %ecx,%ecx
80106cd2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106cd7:	89 f0                	mov    %esi,%eax
80106cd9:	89 f3                	mov    %esi,%ebx
80106cdb:	e8 e0 fa ff ff       	call   801067c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ce0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ce6:	eb 0f                	jmp    80106cf7 <freevm+0x37>
80106ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cef:	90                   	nop
80106cf0:	83 c3 04             	add    $0x4,%ebx
80106cf3:	39 df                	cmp    %ebx,%edi
80106cf5:	74 23                	je     80106d1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cf7:	8b 03                	mov    (%ebx),%eax
80106cf9:	a8 01                	test   $0x1,%al
80106cfb:	74 f3                	je     80106cf0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d02:	83 ec 0c             	sub    $0xc,%esp
80106d05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d0d:	50                   	push   %eax
80106d0e:	e8 bd b6 ff ff       	call   801023d0 <kfree>
80106d13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d16:	39 df                	cmp    %ebx,%edi
80106d18:	75 dd                	jne    80106cf7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d20:	5b                   	pop    %ebx
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d24:	e9 a7 b6 ff ff       	jmp    801023d0 <kfree>
    panic("freevm: no pgdir");
80106d29:	83 ec 0c             	sub    $0xc,%esp
80106d2c:	68 81 79 10 80       	push   $0x80107981
80106d31:	e8 4a 96 ff ff       	call   80100380 <panic>
80106d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3d:	8d 76 00             	lea    0x0(%esi),%esi

80106d40 <setupkvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	56                   	push   %esi
80106d44:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d45:	e8 46 b8 ff ff       	call   80102590 <kalloc>
80106d4a:	89 c6                	mov    %eax,%esi
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	74 42                	je     80106d92 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d50:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d53:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d58:	68 00 10 00 00       	push   $0x1000
80106d5d:	6a 00                	push   $0x0
80106d5f:	50                   	push   %eax
80106d60:	e8 8b d8 ff ff       	call   801045f0 <memset>
80106d65:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d68:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d6b:	83 ec 08             	sub    $0x8,%esp
80106d6e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d71:	ff 73 0c             	pushl  0xc(%ebx)
80106d74:	8b 13                	mov    (%ebx),%edx
80106d76:	50                   	push   %eax
80106d77:	29 c1                	sub    %eax,%ecx
80106d79:	89 f0                	mov    %esi,%eax
80106d7b:	e8 b0 f9 ff ff       	call   80106730 <mappages>
80106d80:	83 c4 10             	add    $0x10,%esp
80106d83:	85 c0                	test   %eax,%eax
80106d85:	78 19                	js     80106da0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d87:	83 c3 10             	add    $0x10,%ebx
80106d8a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d90:	75 d6                	jne    80106d68 <setupkvm+0x28>
}
80106d92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d95:	89 f0                	mov    %esi,%eax
80106d97:	5b                   	pop    %ebx
80106d98:	5e                   	pop    %esi
80106d99:	5d                   	pop    %ebp
80106d9a:	c3                   	ret    
80106d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d9f:	90                   	nop
      freevm(pgdir);
80106da0:	83 ec 0c             	sub    $0xc,%esp
80106da3:	56                   	push   %esi
      return 0;
80106da4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106da6:	e8 15 ff ff ff       	call   80106cc0 <freevm>
      return 0;
80106dab:	83 c4 10             	add    $0x10,%esp
}
80106dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106db1:	89 f0                	mov    %esi,%eax
80106db3:	5b                   	pop    %ebx
80106db4:	5e                   	pop    %esi
80106db5:	5d                   	pop    %ebp
80106db6:	c3                   	ret    
80106db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbe:	66 90                	xchg   %ax,%ax

80106dc0 <kvmalloc>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106dc6:	e8 75 ff ff ff       	call   80106d40 <setupkvm>
80106dcb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106dd5:	0f 22 d8             	mov    %eax,%cr3
}
80106dd8:	c9                   	leave  
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106de0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106de0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106de1:	31 c9                	xor    %ecx,%ecx
{
80106de3:	89 e5                	mov    %esp,%ebp
80106de5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106deb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dee:	e8 bd f8 ff ff       	call   801066b0 <walkpgdir>
  if(pte == 0)
80106df3:	85 c0                	test   %eax,%eax
80106df5:	74 05                	je     80106dfc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106df7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dfa:	c9                   	leave  
80106dfb:	c3                   	ret    
    panic("clearpteu");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 92 79 10 80       	push   $0x80107992
80106e04:	e8 77 95 ff ff       	call   80100380 <panic>
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e19:	e8 22 ff ff ff       	call   80106d40 <setupkvm>
80106e1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e21:	85 c0                	test   %eax,%eax
80106e23:	0f 84 a0 00 00 00    	je     80106ec9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e2c:	85 c9                	test   %ecx,%ecx
80106e2e:	0f 84 95 00 00 00    	je     80106ec9 <copyuvm+0xb9>
80106e34:	31 f6                	xor    %esi,%esi
80106e36:	eb 4e                	jmp    80106e86 <copyuvm+0x76>
80106e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e40:	83 ec 04             	sub    $0x4,%esp
80106e43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e4c:	68 00 10 00 00       	push   $0x1000
80106e51:	57                   	push   %edi
80106e52:	50                   	push   %eax
80106e53:	e8 38 d8 ff ff       	call   80104690 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e58:	58                   	pop    %eax
80106e59:	5a                   	pop    %edx
80106e5a:	53                   	push   %ebx
80106e5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e61:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e66:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e6c:	52                   	push   %edx
80106e6d:	89 f2                	mov    %esi,%edx
80106e6f:	e8 bc f8 ff ff       	call   80106730 <mappages>
80106e74:	83 c4 10             	add    $0x10,%esp
80106e77:	85 c0                	test   %eax,%eax
80106e79:	78 39                	js     80106eb4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106e7b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e81:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106e84:	76 43                	jbe    80106ec9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e86:	8b 45 08             	mov    0x8(%ebp),%eax
80106e89:	31 c9                	xor    %ecx,%ecx
80106e8b:	89 f2                	mov    %esi,%edx
80106e8d:	e8 1e f8 ff ff       	call   801066b0 <walkpgdir>
80106e92:	85 c0                	test   %eax,%eax
80106e94:	74 3e                	je     80106ed4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106e96:	8b 18                	mov    (%eax),%ebx
80106e98:	f6 c3 01             	test   $0x1,%bl
80106e9b:	74 44                	je     80106ee1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106e9d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e9f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106ea5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106eab:	e8 e0 b6 ff ff       	call   80102590 <kalloc>
80106eb0:	85 c0                	test   %eax,%eax
80106eb2:	75 8c                	jne    80106e40 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106eb4:	83 ec 0c             	sub    $0xc,%esp
80106eb7:	ff 75 e0             	pushl  -0x20(%ebp)
80106eba:	e8 01 fe ff ff       	call   80106cc0 <freevm>
  return 0;
80106ebf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106ec6:	83 c4 10             	add    $0x10,%esp
}
80106ec9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ecf:	5b                   	pop    %ebx
80106ed0:	5e                   	pop    %esi
80106ed1:	5f                   	pop    %edi
80106ed2:	5d                   	pop    %ebp
80106ed3:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106ed4:	83 ec 0c             	sub    $0xc,%esp
80106ed7:	68 9c 79 10 80       	push   $0x8010799c
80106edc:	e8 9f 94 ff ff       	call   80100380 <panic>
      panic("copyuvm: page not present");
80106ee1:	83 ec 0c             	sub    $0xc,%esp
80106ee4:	68 b6 79 10 80       	push   $0x801079b6
80106ee9:	e8 92 94 ff ff       	call   80100380 <panic>
80106eee:	66 90                	xchg   %ax,%ax

80106ef0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ef0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ef1:	31 c9                	xor    %ecx,%ecx
{
80106ef3:	89 e5                	mov    %esp,%ebp
80106ef5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106efb:	8b 45 08             	mov    0x8(%ebp),%eax
80106efe:	e8 ad f7 ff ff       	call   801066b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f03:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f06:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f0d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f10:	05 00 00 00 80       	add    $0x80000000,%eax
80106f15:	83 fa 05             	cmp    $0x5,%edx
80106f18:	ba 00 00 00 00       	mov    $0x0,%edx
80106f1d:	0f 45 c2             	cmovne %edx,%eax
}
80106f20:	c3                   	ret    
80106f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop

80106f30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 0c             	sub    $0xc,%esp
80106f39:	8b 75 14             	mov    0x14(%ebp),%esi
80106f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f3f:	85 f6                	test   %esi,%esi
80106f41:	75 38                	jne    80106f7b <copyout+0x4b>
80106f43:	eb 6b                	jmp    80106fb0 <copyout+0x80>
80106f45:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f4b:	89 fb                	mov    %edi,%ebx
80106f4d:	29 d3                	sub    %edx,%ebx
80106f4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106f55:	39 f3                	cmp    %esi,%ebx
80106f57:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f5a:	29 fa                	sub    %edi,%edx
80106f5c:	83 ec 04             	sub    $0x4,%esp
80106f5f:	01 c2                	add    %eax,%edx
80106f61:	53                   	push   %ebx
80106f62:	ff 75 10             	pushl  0x10(%ebp)
80106f65:	52                   	push   %edx
80106f66:	e8 25 d7 ff ff       	call   80104690 <memmove>
    len -= n;
    buf += n;
80106f6b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106f6e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106f74:	83 c4 10             	add    $0x10,%esp
80106f77:	29 de                	sub    %ebx,%esi
80106f79:	74 35                	je     80106fb0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106f7b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f7d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106f80:	89 55 0c             	mov    %edx,0xc(%ebp)
80106f83:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f89:	57                   	push   %edi
80106f8a:	ff 75 08             	pushl  0x8(%ebp)
80106f8d:	e8 5e ff ff ff       	call   80106ef0 <uva2ka>
    if(pa0 == 0)
80106f92:	83 c4 10             	add    $0x10,%esp
80106f95:	85 c0                	test   %eax,%eax
80106f97:	75 af                	jne    80106f48 <copyout+0x18>
  }
  return 0;
}
80106f99:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fa1:	5b                   	pop    %ebx
80106fa2:	5e                   	pop    %esi
80106fa3:	5f                   	pop    %edi
80106fa4:	5d                   	pop    %ebp
80106fa5:	c3                   	ret    
80106fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fad:	8d 76 00             	lea    0x0(%esi),%esi
80106fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fb3:	31 c0                	xor    %eax,%eax
}
80106fb5:	5b                   	pop    %ebx
80106fb6:	5e                   	pop    %esi
80106fb7:	5f                   	pop    %edi
80106fb8:	5d                   	pop    %ebp
80106fb9:	c3                   	ret    
