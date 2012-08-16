#********************************************************************
# Variables
#********************************************************************
.set UART, 0x84000000
.set RxFIFO, 0x0
.set TxFIFO, 0x4
.set STATREG, 0x8
.set CTRLREG, 0xC
#
.set BUT, 0x81400000
.set DATA, 0x0
.set DDR, 0x4
.set GIE, 0x11C
.set IPIER, 0x128
.set IPISR, 0x120
#   11111
#   CWNES
#
.set INTC, 0x81800000
.set ISR, 0x0
.set IPR, 0x4
.set IER, 0x8
.set IAR, 0xC
.set MER, 0x1C
#
.set XVAL, 0x0000007F
.set YVAL, 0x0000001F
.set RVAL, 0x0000000F
#
.set LCD, 0x81450000
.set DLL, 0x1000
.set DLM, 0x1004
.set LSR, 0x1014
.set RBR, 0x00
.set THR, 0x04
#
.set SEC, 200000000
.set MIL, 20000000

#********************************************************************
# External ISR
#********************************************************************
	.org 0x500
	stmw r24, 0(r3)		# Context switch
	lmw r24, 0x40(r3)	#
srtext:	lwz r31, IPR(r5)	# Get pending register
	andi. r0, r31, 4	# buttons?
	bf 2, butn		#
	andi. r0, r31, 8	# UART?
	li r31, 8		# ack UART interrupt
	stw r31, IAR(r5)	#
	bt 2, endext		#
#
	lwz r31, STATREG(r2)	# check valid data
	andi. r0, r31, 1	#
	bt 2, srtext		#
	lwz r31, RxFIFO(r2)	# get data
	cmpi 0, r31, 0x29	# check if number
	bf 1, chklt		#
chknu:	cmpi 0, r31, 0x40	#
	bt 2, num		#
chklt:	cmpi 0, r31, 0x68	# h is left
	bt 2, left		#
	cmpi 0, r31, 0x6A	# j is down
	bt 2, down		#
	cmpi 0, r31, 0x6B	# k is up
	bt 2, up		#
	cmpi 0, r31, 0x6C	# l is right
	bt 2, right		#
	cmpi 0, r31, 0x63	# c is clear
	bt 2, cls		#
	b srtext		#
num:	li r30, 0x30		#
	neg r30, r30		#
	add r19, r30, r31	#
	b srtext		#
left:	li r9, 8		# change direction to right
	b srtext		#
up:	li r9, 4		#
	b srtext		#
down:	li r9, 1		#
	b srtext		#
right:	li r9, 2		#
	b srtext		#
cls:	li r9, 16		#
	b srtext		#
#
butn:	li r31, 1		# Ack interrupt at buttons
	stw r31, IPISR(r4)	#
	li r31, 4		# Ack interrupt at intc
	stw r31, IAR(r5)	#
	lwz r24, DATA(r4)	# Change direction to button pushed
	cmpi 2, r24, 0		# check if 0
	bt 10, srtext		# don't zero direction register
	mr r9, r24		#
	b srtext		#
endext:	stmw r24, 0x40(r3)	# Context switch
	lmw r24, 0(r3)		#
	rfi			# Return

#********************************************************************
# PIT Interrupt
#********************************************************************
	.org 0x1000
	 b pitc

#********************************************************************
# Main pointers
#********************************************************************
	.org 0x3000
	lis r1, 0xE		# Pointer to stack
	lis r2, UART@h		# Pointer to UART
	li r3, 0x7000		# Registers
	lis r4, BUT@h		# Pointer to buttons
	lis r5, INTC@h		# Pointer to interrupt controller
	li r6, 0		# variable passing
	li r7, 0		#
	li r8, 0		#
	li r9, 8		# Current direction / init west
	addi r10, r1, -16	# Pointer to first element in array
	li r11, 0		# grow snake by this value
	li r12, 0		# dead flag
	li r13, 6		# init score
	lis r14, LCD@h		# pointer to LCD
	li r15, 0		# in game TBL
	li r16, 0		# in-game clock update flag
	li r17, 0		# time update flag
	li r18, 0		# in-game time in sec
	li r19, 1		# number of ms to slow game

#********************************************************************
# Screen Init registers
#********************************************************************
	li r24, 0		#
	li r25, 0		#
	li r26, 0		#
	li r27, 0		#
	li r28, 0		#
	li r29, 10		# For bin->ascii
	li r30, 1		# init count value
	li r31, 0		#
	stmw r24, 0x20(r3)	#

#********************************************************************
# External interrupt registers
#********************************************************************
	li r24, 0		#
	li r25, 0		#
	li r26, 0		#
	li r27, 0		#
	li r28, 0		#
	li r29, 0		#
	li r30, 0		#
	li r31, 0		#
	stmw r24, 0x40(r3)	#

#********************************************************************
# Random number registers
#********************************************************************
	lis r24, 0x173B		# init random number
	ori r24, r24, 0x8EC9	#
	li r25, 0		# registers for number creation
	li r26, 0		# 
	li r27, 0		# 
	li r28, 0		# 
	li r29, 1		# value for slw
	li r30, 0		#
	li r31, 0		#
	stmw r24, 0x80(r3)	#

#********************************************************************
# Fruit registers
#********************************************************************
	li r24, 0		#
	li r25, 0		#
	li r26, 0		#
	li r27, 0		#
	li r28, 0		#
	li r29, 0		#
	li r30, 0		#
	li r31, 0		# return address
	stmw r24, 0xC0(r3)	#

#********************************************************************
# Print registers
#********************************************************************
	li r24, 0		#
	li r25, 10		# for bin->ascii
	li r26, 0		#
	li r27, 0		#
	li r28, 0		#
	li r29, 0		#
	li r30, 0		#
	li r31, 0		#
	stmw r24, 0x100(r3)	#

#********************************************************************
# Movement registers
#********************************************************************
	li r24, 0		#
	li r25, 0		#
	li r26, 0		#
	li r27, 0		#
	li r28, 0		#
	li r29, 0		#
	li r30, 0		#
	li r31, 0		#
	stmw r24, 0x120(r3)	#

#********************************************************************
# PIT registers
#********************************************************************
	lis r24, SEC@h		# Value for 1 sec
	ori r24, r24, SEC@l	#
	li r25, 0		# new TBU
	li r26, 0		# new TBL
	li r27, 0		#
	li r28, 0		#
	li r29, 0		# old TBU
	li r30, 0		# old TBL
	li r31, 0		#
	stmw r24, 0x200(r3)	#

#********************************************************************
# Time registers
#********************************************************************
	li r24, 9		# Init Hour
	li r25, 0		# Init Min
	li r26, 0		# Init Sec
	li r27, 0		#
	li r28, 0		#
	li r29, 0		#
	li r30, 0		#
	li r31, 0		#
	stmw r24, 0x220(r3)	#

#********************************************************************
# In-game time registers
#********************************************************************
	li r24, 0		#
	li r25, 0		#
	li r26, 0		#
	li r27, 0		#
	li r28, 0		#
	li r29, 0		#
	li r30, 0		#
	li r31, 0		#
	stmw r24, 0x240(r3)	#

#********************************************************************
# Main Init
#********************************************************************
	li r31, 0x1F		# Enable buttons as input
	stw r31, DDR(r4)	#
	li r31, 1		# Enable button interrupt
	stw r31, IPIER(r4)	#
	stw r31, IPISR(r4)	# Clear interrupt at buttons
	lis r31, 0x8000		# Global enable
	stw r31, GIE(r4)	#
	li r31, 0x10		# Enable UART Interrupt
	stw r31, CTRLREG(r2)	#
#
	li r31, 0xC		# Enable on interrupt controller
	stw r31, IER(r5)	#
	stw r31, IAR(r5)	# Clear interrupt at intc
	li r31, 3		# Master enable
	stw r31, MER(r5)	#
#
	li r31, 0 		# setup LCD as output
	stw r31, DDR(r14) 	#
	li r31,0x02		# set rs=0 and write command set fn
	stw r31,0(r14) 		# (20h) to reg of LCD
	bl wait100 		# wait 100 ns (more actually)
 	li r31,0x42 		# set enable=1 writing 1 in bit 0
 	stw r31,0(r14) 		# of the register of the LCD
 	bl wait300 		# wait 300 ns
 	li r31,0x02 		# set the enable to 0
	stw r31,0(r14) 		# and send to port
 	bl wait60us 		# wait 60 us (note that 39 us is min
 				# time execution for ins function set
 	bl wait60us 		# throw in another wait
	li r6, 0x0F 		# display on
	bl putcmd 		#
 	li r6, 0x01 		# clear screen
 	bl putcmd 		#
 	bl wait2ms 		# wait 2ms
 	li r6, 0x06 		# set enter mode
 	bl putcmd 		# l-to-r
 	li r6, 0x29 		# use 2 lines
 	bl putcmd 		#
#
	lis r31, MIL@h		# value for 0.1s
	ori r31, r31, MIL@l	#
	mtpit r31		# to PIT
	lis r31, 0x0440		# PIE=1 AIE=1
	mttcr r31		# to TCR
	lis r31, 0x0800		# toggle PIS
	mttsr r31		# to TSR
#
	li r31, 0		# Set EVPR
	mtevpr r31		#
	mttbu r31		# clear time base registers
	mttbl r31		#
	wrteei 1		#

#********************************************************************
# Main **************************************************************
#********************************************************************
main:	lis r1, 0xE		# reset stack pointer
	li r9, 8		# reset direction
	li r11, 0		# reset grow value
	li r12, 0		# clear dead flag
	li r13, 6		# reset score
	mftbl r15		# reset in-game TBL
	li r16, 0		# clear in-game update flag
	li r18, 0		# clear in-game time in sec
#
	addi r1, r1, -16	# Dec stack pointer
	li r28, 0		# 0 = head of snake
	li r29, 40		# staring x value
	li r30, 11		# starting y value
	addi r31, r1, -16 	# pointer to next body part
	stmw r28, 0(r1)
#
	mr r1, r31		# Dec stack pointer
	li r28, 1		# 1 = body of snake
	li r29, 41		# starting x value
	addi r31, r1, -16	# pointer to next body part
	stmw r28, 0(r1)
#
	mr r1, r31		# Dec stack pointer
	li r29, 42		# starting x value
	addi r31, r1, -16	# pointer to next body part
	stmw r28, 0(r1)
#
	mr r1, r31		# Dec stack pointer
	li r29, 43
	addi r31, r1, -16	# pointer to next body part
	stmw r28, 0(r1)
#
	mr r1, r31		# Dec stack pointer
	li r29, 44		# starting x value
	addi r31, r1, -16	# pointer to next body part
	stmw r28, 0(r1)
#
	mr r1, r31		# Dec stack pointer
	li r29, 45		# starting x value
	li r31, 0		# null next pointer
	stmw r28, 0(r1)
#
	bl screen		# Initialize screen
	bl fruit		# prepare fruit
	bl new			# add fruit to data array
game:	bl print		# print all elements
	cmpi 0, r16, 0		#
	bt 2, game1		#
	bl gtimep		# print in-game time
game1:	cmpi 0, r17, 0		# check clock flag
	bt 2, game2		#
	bl timep		# print new time if flag set
game2:	andi. r0, r9, 16	# Check if center button pushed
	bf 2, main		# Restart if pushed
	bl move			# move snake
	cmpwi 1, r12, 0		# Check if dead
	bf 6, deads		# go to deads
	lis r31, MIL@h		#
	ori r31, r31, MIL@h	#
	mullw r31, r31, r19	#
	mtctr r31		#
igwait:	bdnz igwait		#
	b game			# continue game
deads:	cmpi 0, r17, 0		# check clock flag
	bt 2, deads1		#
	bl timep		# print new time if flag set
deads1:	andi. r0, r9, 16	# wait for clear command to restart
	bt 2, deads		# still dead
	b main			# restart game

#********************************************************************
# PIT ISR
#********************************************************************
pitc:	stmw r24, 0(r3)		# context switch
	lmw r24, 0x200(r3)	#
	lis r31, 0x0800		# Ack PIT interrupt
	mttsr r31		#
lpitc:	mftbu r25		# get TBU
	mftbl r26		# get TBL
	mftbu r27		# get TBU again
	cmpw 1, r25, r27	# Check for TBU rollover
	bf 6, lpitc		# get registers again
	subf r27, r30, r26	# time elapsed since last check
	cmpw 1, r27, r24	# is it one second?
	bt 4, gmepit		# end if less
	li r17, 0x7FFF		# flag to update time
	mr r29, r25		#
	mr r30, r26		#
gmepit:	subf r27, r15, r26	#
	cmpw 1, r27, r24	#
	bt 4, endpit		#
	li r16, 0x7FFF		# flag to update
	mr r15, r26		#
endpit:	stmw r24, 0x200(r3)	# context switch
	lmw r24, 0(r3)		#
	rfi			# return

#********************************************************************
# Initialize screen
#********************************************************************
screen:	stmw r24, 0(r3)		# Context switch
	lmw r24, 0x20(r3)	#
	mflr r24		#
#
clc:	lwz r31, STATREG(r2)	# Check TxFIFO empty
	andi. r0, r31, 4	#
	beq clc			#
#
	li r31, 0x1B		# Clear screen
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x32		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x4A		#
	stw r31, TxFIFO(r2)	#
#
	li r30, 1		#
	li r31, 80		# 80 across
	mtctr r31		#
box1:	lwz r31, STATREG(r2)	# Check TxFIFO empty
	andi. r0, r31, 4	#
	beq box1		# Wait for TxFIFO empty
#
	mr r6, r30		# Count to ascii
	bl aascii		#
#
	li r31, 0x1B		# Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x31		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x3B		#
	stw r31, TxFIFO(r2)	#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x48		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x58		# Send X
	stw r31, TxFIFO(r2)	#
#
box1a:	lwz r31, STATREG(r2)	# Check TxFIFO empty
	andi. r0, r31, 4	#
	beq box1a		# Wait for TxFIFO empty
#
	li r31, 0x1B		# Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x32		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x33		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x3B		#
	stw r31, TxFIFO(r2)	#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x48		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x58		# Send X
	stw r31, TxFIFO(r2)	#
#
	addi r30, r30, 1	# Increment count
	bdnz box1		#
#
	li r31, 23		# 23 rows
	mtctr r31		#
	li r30, 1		# Reset count
box2:	lwz r31, STATREG(r2)	#
	andi. r0, r31, 4	#
	beq box2		# Wait for TxFIFO empty
#
	mr r6, r30		# Count to ascii
	bl aascii		#
#
	li r31, 0x1B		# Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		# ascii for [
	stw r31, TxFIFO(r2)	#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x3B		# ascii for ;
	stw r31, TxFIFO(r2)	#
	li r31, 0x31		# row 1
	stw r31, TxFIFO(r2)	#
	li r31, 0x48		# ascii for H
	stw r31, TxFIFO(r2)	#
	li r31, 0x58		# Send X
	stw r31, TxFIFO(r2)	#
#
box2a:	lwz r31, STATREG(r2)	# Check TxFIFO empty
	andi. r0, r31, 4	#
	beq box2a		# Wait for TxFIFO empty
#
	li r31, 0x1B		# Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		#
	stw r31, TxFIFO(r2)	#
	stw r6, TxFIFO(r2)	# column
	stw r7, TxFIFO(r2)	#
	li r31, 0x3B		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x38		# row 80
	stw r31, TxFIFO(r2)	#
	li r31, 0x30		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x48		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x58		# Send X
	stw r31, TxFIFO(r2)	#
#
	addi r30, r30, 1	#
	bdnz box2		#
#
box3:	lwz r31, STATREG(r2)	#
	andi. r0, r31, 4	#
	beq box3		#
#
	li r31, 0x1B		# Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x31		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x31		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x3B		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x34		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x30		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x48		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x23		# head #
	stw r31, TxFIFO(r2)	#
	li r31, 0x5E		# body ^
	stw r31, TxFIFO(r2)	#
	stw r31, TxFIFO(r2)	#
	stw r31, TxFIFO(r2)	#
	stw r31, TxFIFO(r2)	#
	stw r31, TxFIFO(r2)	#
#
	mtlr r24		#
	stmw r24, 0x20(r3)	# Context switch
	lmw r24, 0(r3)		#
	blr			# Return

#********************************************************************
# New data array element
# Input:
#	R6 - data type of new element
#	R7 - X location of new element
#	R8 - Y location of new element
#********************************************************************
new:	stmw r24, 0x180(r3)	# Context switch
	lmw r28, 0(r1)		# load last data element
	addi r31, r1, -16	# Change next pointer to new element
	stmw r28, 0(r1)		# Send element back
	addi r1, r1, -16	# Dec stack pointer
	mr r28, r6		# R6 contains element type
	mr r29, r7		# R7 contains x value
	mr r30, r8		# R8 contains y value
	li r31, 0		# Next pointer null
	stmw r28, 0(r1)		# Store into stack
	lmw r24, 0x180(r3)	# Context switch
	blr			#

#********************************************************************
# Random number generator
# Output:
#	R6 - random number
#********************************************************************
rand:	stmw r24, 0xC0(r3)	# Context switch
	lmw r24, 0x80(r3)	#
	srawi r25, r24, 18	# right shift - put data
	andi. r25, r25, 1	# Strip bits
	srawi r26, r24, 5	# again...
	andi. r26, r26, 1	#
	srawi r27, r24, 2	#
	andi. r27, r27, 1	#
	srawi r28, r24, 1	#
	andi. r28, r28, 1	#
	xor r25, r25, r26	# xor stuff together
	xor r25, r25, r27	#
	xor r25, r25, r28	#
	slw r24, r24, r29	# shift number left one bit
	or r24, r24, r25	# or in r25
	mr r6, r24		# move to output variable
	stmw r24, 0x80(r3)	# Context switch
	lmw r24, 0xC0(r3)	#
	blr			# Return

#********************************************************************
# Create Fruit
# Output:
#	R6 - value of fruit
#	R7 - X location of fruit
#	R8 - Y location of fruit
#********************************************************************
fruit:	stmw r24, 0(r3)		# Context switch
	lmw r24, 0xC0(r3)	#
	mflr r24		# Save return address
	li r25, RVAL@l		# Mask for value
	li r26, XVAL@l		# Mask for x pos
	li r27, YVAL@l		# Mask for y pos
#
fruv:	bl rand			# Get random number
	and r28, r6, r25	# Get value for fruit
	cmpi 0, r28, 1		# check >1
	bf 1, fruv		# get new number if not >1
	cmpi 0, r28, 10		# check <10
	bf 0, fruv		# get new if not <10
#
frux:	srwi r29, r6, 9		#
	and r29, r29, r26	# get x value for fruit
	cmpi 0, r29, 1		# Check >1
	bf 1, fruv		#
	cmpi 0, r29, 80		# Check <80
	bf 0, fruv		#
#
fruy:	srwi r30, r6, 4		#
	and r30, r30, r27	# get y value for fruit
	cmpi 0, r30, 1		# Check >1
	bf 1, fruv		#
	cmpi 0, r30, 23		# Check <23
	bf 0, fruv		#
#
	mr r6, r28		# Return values
	mr r7, r29		#
	mr r8, r30		#
#
	mr r26, r10		# Address for head
	li r27, 0		# check bits for x,y
chkfru:	lmw r28, 0(r26)		# load element
	cmpw 0, r29, r7		# x values equal?
	bf 2, fruxne		#
	addi r27, r27, 1	#
fruxne: cmpw 0, r30, r8		# y values equal?
	bf 2, fruyne		#
	addi r27, r27, 2	#
fruyne: cmpi 0, r27, 3		# x and y equal?
	bt 2, frux		# fruit in body, redo
	cmpi 0, r31, 0		# chk nxt ptr
	bt 2, endfru		# if null then done checking
	mr r26, r31		# nxt ptr
	li r27, 0		# check bits for x,y equal to element
	b chkfru		# continue checking
#
endfru:	mtlr r24		# Replace return address
	stmw r24, 0xC0(r3)	# Context switch
	lmw r24, 0(r3)		#
	blr			# Return

#********************************************************************
# Print subroutine
#********************************************************************
print:	stmw r24, 0(r3)		# Context switch
	lmw r24, 0x100(r3)	#
	mr r24, r10		# addr for first data element
	mflr r25		#
	li r31, 3		# Only print 3 elements
	mtctr r31		#
prnt:	lmw r28, 0(r24)		# Get data element
	mr r24, r31		# Save next address
prntw:	lwz r31, STATREG(r2)	# Check TxFIFO empty
	andi. r0, r31, 4	#
	beq prntw		# Wait for TxFIFO empty
#
	li r31, 0x1B		# ESC Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		# ascii for [
	stw r31, TxFIFO(r2)	#
	mr r6, r30		# Y value to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x3B		# ascii for ;
	stw r31, TxFIFO(r2)	#
	mr r6, r29		# X value to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x48		# ascii for H
	stw r31, TxFIFO(r2)	#
#
	cmpi 0, r28, 0		# Check if head
	bf 2, prntb		#
	li r31, 0x23		# ascii for #
	stw r31, TxFIFO(r2)	#
	b endp			#
#
prntb:	cmpi 0, r28, 1		# Check if body 
	bf 2, prntf		#
	li r31, 0x5E		# ascii for ^
	stw r31, TxFIFO(r2)	#
	b endp			#
#
prntf:	addi r28, r28, 0x30	# Fruit value to ascii
	stw r28, TxFIFO(r2)	#
#
endp:	cmpi 0, r28, 1		# Check to get first 2 elements
	bf 2, eendp		# and the last element
	mr r24, r1		# 
eendp:	bdnz  prnt		# Keep printing if not null
	mtlr r25		#
#
prnts:	lwz r31, STATREG(r2)	# TxFIFO empty?
	andi. r0, r31, 4	#
	bt 2, prnts		# wait for empty
	li r31, 0x1B		# ESC Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		# ascii for [
	stw r31, TxFIFO(r2)	#
	li r31, 0x32		# row 24
	stw r31, TxFIFO(r2)	#
	li r31, 0x34		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x3B		# ascii for ;
	stw r31, TxFIFO(r2)	#
	li r31, 0x31		# Column 1
	stw r31, TxFIFO(r2)	#
	li r31, 0x48		# ascii for H
	stw r31, TxFIFO(r2)	#
prntss:	lwz r31, STATREG(r2)	# TxFIFO empty?
	andi. r0, r31, 4	#
	bt 2, prntss		# wait for empty
	li r31, 0x53		# S
	stw r31, TxFIFO(r2)	#
	li r31, 0x63		# c
	stw r31, TxFIFO(r2)	#
	li r31, 0x6F		# o
	stw r31, TxFIFO(r2)	#
	li r31, 0x72		# r
	stw r31, TxFIFO(r2)	#
	li r31, 0x65		# e
	stw r31, TxFIFO(r2)	#
	li r31, 0x3A		# :
	stw r31, TxFIFO(r2)	#
	li r31, 0x20		# Space
	stw r31, TxFIFO(r2)	#
#
	li r24, 1000		# for bin->ascii
	li r25, 100		#
	li r26, 10		#
	divw r27, r13, r24	# 1000s place
	mullw r31, r27, r24	#
	subf r31, r31, r13	# last 3 digits
	divw r28, r31, r25	# 100s place
	mullw r29, r28, r25	#
	subf r31, r29, r31	# last 2 digits
	divw r29, r31, r26	# 10s place
	mullw r30, r29, r26	#
	subf r30, r30, r31	# 1s place
	addi r27, r27, 0x30	# to ascii
	addi r28, r28, 0x30	#
	addi r29, r29, 0x30	#
	addi r30, r30, 0x30	#
	stw r27, TxFIFO(r2)	# Print score
	stw r28, TxFIFO(r2)	#
	stw r29, TxFIFO(r2)	#
	stw r30, TxFIFO(r2)	#
#
	stmw r24, 0x100(r3)	# Context switch
	lmw r24, 0(r3)		#
	blr			# Return

#********************************************************************
# Print time
#********************************************************************
timep:	stmw r24, 0(r3)		# context switch
	lmw r24, 0x220(r3)	#
	mflr r30		# save link address
	li r17, 0		# reset flag
	addi r26, r26, 1	# add 1 to seconds
	cmpi 0, r26, 60		# >60?
	bt 0, timmin		#
	li r26, 0		# back to 0
	addi r25, r25, 1	# add 1 to min
timmin:	cmpi 0, r25, 60		# >60?
	bt 0, timhr		#
	li r25, 0		# back to 0
	addi r24, r24, 1	# add 1 to hr
#
timhr:	lwz r31, STATREG(r2)	# TxFIFO empty?
	andi. r0, r31, 4	#
	bt 2, timhr		# wait for empty
	li r31, 0x1B		# ESC Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		# ascii for [
	stw r31, TxFIFO(r2)	#
	li r31, 0x32		# row 24
	stw r31, TxFIFO(r2)	#
	li r31, 0x34		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x3B		# ascii for ;
	stw r31, TxFIFO(r2)	#
	li r31, 0x36		# Column 65
	stw r31, TxFIFO(r2)	#
	li r31, 0x35		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x48		# ascii for H
	stw r31, TxFIFO(r2)	#
	li r31, 0x54		# T
	stw r31, TxFIFO(r2)	#
	li r31, 0x69		# i
	stw r31, TxFIFO(r2)	#
	li r31, 0x6D		# m
	stw r31, TxFIFO(r2)	#
	li r31, 0x65		# e
	stw r31, TxFIFO(r2)	#
	li r31, 0x3A		# :
	stw r31, TxFIFO(r2)	#
	li r31, 0x20		# Space
	stw r31, TxFIFO(r2)	#
twait:	lwz r31, STATREG(r2)	# TxFIFO empty?
	andi. r0, r31, 4	#
	bt 2, twait		# wait for empty
	mr r6, r24		# hours to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x3A		# :
	stw r31, TxFIFO(r2)	#
	mr r6, r25		# minutes to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x3A		# :
	stw r31, TxFIFO(r2)	#
	mr r6, r26		# sec to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
#
 	li r31,0x02 		# set the enable to 0
	stw r31,0(r14) 		# and send to port
	li r6, 0x80		# cursor to TL
	bl putcmd		#
	li r6, 0x03		# cursor to load point
	bl putcmd		#
	mr r6, r24		# hr to ascii
	bl aascii		#
	bl putc			# print
	mr r6, r7		#
	bl putc			#
	li r6, 0x3A		# :
	bl putc			#
	mr r6, r25		# min to ascii
	bl aascii		#
	bl putc			# print
	mr r6, r7		#
	bl putc			#
	li r6, 0x3A		# :
	bl putc			#
	mr r6, r26		# sec to ascii
	bl aascii		#
	bl putc			# print
	mr r6, r7		#
	bl putc			#
#
	mtlr r30		# return link address
	stmw r24, 0x220(r3)	# context switch
	lmw r24, 0(r3)		#
	blr			# return

#********************************************************************
# Print in-game time
#********************************************************************
gtimep:	stmw r24, 0(r3)		# context switch
	lmw r24, 0x240(r3)	#
	li r16, 0		# reset flag
	mflr r24		# save link address
	addi r18, r18, 1	# add 1 sec
	mr r25, r18		# save sec to r25
	li r26, 60		# 60 sec in min
	li r28, 0
#
gmin:	subf r25, r26, r25	# subtract 1 min from time
	addi r28, r28, 1	# add 1 min
	cmpi 0, r25, 0		# check if non positive
	bf 0, gmin		#
	add r29, r26, r25	# get seconds
	addi r28, r28, -1	# correct min
	cmpi 0, r28, 100	# compare to 100
	bt 0, gwait		#
	li r28, 0		# reset to 0
#
gwait:	lwz r31, STATREG(r2)	# TxFIFO empty?
	andi. r0, r31, 4	#
	bt 2, gwait		# wait for empty
	li r31, 0x1B		# ESC Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		# ascii for [
	stw r31, TxFIFO(r2)	#
	li r31, 0x32		# row 24
	stw r31, TxFIFO(r2)	#
	li r31, 0x34		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x3B		# ascii for ;
	stw r31, TxFIFO(r2)	#
	li r31, 0x32		# Column 20
	stw r31, TxFIFO(r2)	#
	li r31, 0x30		#
	stw r31, TxFIFO(r2)	#
	li r31, 0x48		# ascii for H
	stw r31, TxFIFO(r2)	#
	mr r6, r28		# min to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x3A		# :
	stw r31, TxFIFO(r2)	#
	mr r6, r29		# sec to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
#
 	li r31,0x02 		# set the enable to 0
	stw r31,0(r14) 		# and send to port
	li r6, 0xC0		# cursor to BL
	bl putcmd		#
	mr r6, r28		# min to ascii
	bl aascii		#
	bl putc			# print
	mr r6, r7		#
	bl putc			#
	li r6, 0x3A		# :
	bl putc			#
	mr r6, r29		# sec to ascii
	bl aascii		#
	bl putc			# print
	mr r6, r7		#
	bl putc			#
	li r6, 0x20		# space
	bl putc			#
	bl putc			#
	bl putc			#
	bl putc			#
	bl putc			#
	bl putc			#
#
	li r24, 1000		# for bin->ascii
	li r25, 100		#
	li r26, 10		#
	divw r27, r13, r24	# 1000s place
	mullw r31, r27, r24	#
	subf r31, r31, r13	# last 3 digits
	divw r28, r31, r25	# 100s place
	mullw r29, r28, r25	#
	subf r31, r29, r31	# last 2 digits
	divw r29, r31, r26	# 10s place
	mullw r30, r29, r26	#
	subf r30, r30, r31	# 1s place
	addi r27, r27, 0x30	# to ascii
	addi r28, r28, 0x30	#
	addi r29, r29, 0x30	#
	addi r30, r30, 0x30	#
	mr r6, r27		# Print score
	bl putc			#
	mr r6, r28		#
	bl putc			#
	mr r6, r28		#
	bl putc			#
	mr r6, r28		#
	bl putc			#
#
	mtlr r24		# return link address
	stmw r24, 0x240(r3)	# context switch
	lmw r24, 0(r3)		#
	blr			# return

#********************************************************************
# Movement
#********************************************************************
move:	stmw r24, 0(r3)		# Context switch
	lmw r24, 0x120(r3)	#
	lmw r28, 0(r10)		# Get head from array
	mr r7, r29		# save old x,y
	mr r8, r30		#
	andi. r0, r9, 8		# west?
	bt 2, moves		#
	addic r29, r29, -1	# --x
	b chmove		#
#
moves:	andi. r0, r9, 1		# south?
	bt 2, movee		#
	addic r30, r30, -1	# --y
	b chmove		#
#
movee:	andi. r0, r9, 2		# east?
	bt 2, moven		#
	addi r29, r29, 1	# x++
	b chmove		#
#
moven:	addi r30, r30, 1	# y++
#
chmove:	stmw r28, 0(r10)	# Store new head to memory
	cmpi 0, r29, 1		# Check if head hit edges
	bt 2, dead		# if hit then dead
	cmpi 0, r29, 80		#
	bt 2, dead		#
	cmpi 0, r30, 1		#
	bt 2, dead		#
	cmpi 0, r30, 23		#
	bt 2, dead		#
#
	mr r24, r29		# save new head x,y
	mr r25, r30		#
#
chkmov:	mr r26, r31		# nxt ptr
	li r27, 0		# check bits for x,y equal to element
	lmw r28, 0(r26)		# load element
	cmpi 0, r28, 1		# check element type
	bt 1, chkfrt		# if >1 then fruit
	cmpw 0, r29, r24	# x values equal?
	bf 2, chkxne		#
	addi r27, r27, 1	#
chkxne: cmpw 0, r30, r25	# y values equal?
	bf 2, chkyne		#
	addi r27, r27, 2	#
chkyne: cmpi 0, r27, 3		# x and y equal?
	bt 2, dead		# head hit body, dead
	cmpi 0, r31, 0		# chk nxt ptr
	bt 2, mmove		# if null then done checking
	b chkmov		# continue checking
#
chkfrt:	cmpw 0, r29, r24	# x values equal?
	bf 2, frtxne		#
	addi r27, r27, 1	#
frtxne:	cmpw 0, r30, r25	# y values equal
	bf 2, frtyne		#
	addi r27, 27, 2		#
frtyne:	cmpi 0, r27, 3		# x and y equal?
	bf 2, mmove		#
	add r11, r11, r28	# add to grow value
	add r13, r13, r28	# add to score
	addi r1, r1, 16		# inc stack pointer
	lmw r28, 0(r1)		# null nxt ptr of last body element
	li r31, 0		#
	stmw r28, 0(r1)		#
#
mmove:	lmw r28, 0(r10)		# get head again
wmove:	mr r24, r7		# x of next element
	mr r25, r8		# y of next element
	mr r26, r31		# save address of element
	lmw r28, 0(r26)		# get next element
	cmpi 0, r28, 1		# check if fruit
	bt 1, nxtmov		# no change to fruit
	mr r7, r29		# old x value
	mr r8, r30		# old y value
	mr r29, r24		# new x value
	mr r30, r25		# new y value
	stmw r28, 0(r26)	# save element
	cmpi 0, r31, 0		# check for null nxt ptr
	bf 2, wmove		#
#
nxtmov:	mflr r24		# save return link
	cmpi 0, r11, 0		# check if snake is growing
	bt 2, nogrow		# not growing
	li r6, 1		# new body element
	bl new			# create new body element
	mtlr r24		# reset link
	addi r11, r11, -1	# dec grow value
	cmpi 0, r11, 0		# check if stopped growing
	bf 2, endmov		# end moving if still growing
	bl fruit		# create new fruit element
	bl new			#
	mtlr r24		# reset link
	b endmov		# end moving
nogrow:	bl space		# replace end with space
	mtlr r24		# reset link
	b endmov		# end moving
#
dead:	li r12, 0x7FF		# Flag if dead
endmov:	stmw r24, 0x120(r3)	# Context switch
	lmw r24, 0(r3)		#
	blr			# Return
#
space:	stmw r24, 0x140(r3)	#
	mflr r24		#
	mr r25, r7		#
	mr r26, r8		#
space1:	lwz r31, STATREG(r2)	# TXFIFO empty?
	andi. r0, r31, 4	#
	bt 2, space1		# wait for empty
	li r31, 0x1B		# ESC Move cursor
	stw r31, TxFIFO(r2)	#
	li r31, 0x5B		# ascii for [
	stw r31, TxFIFO(r2)	#
	mr r6, r26		# Y value to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x3B		# ascii for ;
	stw r31, TxFIFO(r2)	#
	mr r6, r25		# X value to ascii
	bl aascii		#
	stw r6, TxFIFO(r2)	#
	stw r7, TxFIFO(r2)	#
	li r31, 0x48		# ascii for H
	stw r31, TxFIFO(r2)	#
	li r31, 0x20		# ascii for space
	stw r31, TxFIFO(r2)	#
	mtlr r24		#
	lmw r24, 0x140(r3)	#
	blr			#

#********************************************************************
# Binary to ASCII
# Input: 
#	R6 - Two digit binary number to ASCII
#
# Output:
#	R6 - First digit
#	R7 - Second digit
#********************************************************************
aascii:	stmw r24, 0x160(r3)	# context switch
	li r29, 10		# for bin -> ascii
	divw r27, r6, r29	# tens digit
	mullw r28, r27, r29	#
	subf r28, r28, r6	# ones digit
	addi r6, r27, 0x30	# to ASCII
	addi r7, r28, 0x30	#
eascii:	lmw r24, 0x160(r3)	# context switch
	blr			# return

#********************************************************************
# Wait Code
#********************************************************************

wait100:
	li r31, 2		# use r31 to send val
	mtctr r31		# to counter reg
w100a:	bdz w100b		# branch out when done
	b w100a			# not done - try again
w100b:	blr			# get out when done

wait300:
	li r31, 12		# use r31 to send val
	mtctr r31		# to counter reg
w300a:	bdz w300b		# branch out when done
	b w300a			# not done - try again
w300b:	blr			# get out when done

wait1500:
	li r31, 20		# use r31 to send val
	mtctr r31		# to counter reg
w1500a:	bdz w1500b		# branch out when done
	b w1500a		# not done - try again
w1500b:	blr			# get out when done

wait60us:
	li r31, 4000		# use r31 to send val
	mtctr r31		# to counter reg
w60ua:	bdz w60ub		# branch out when done
	b w60ua			# not done - try again
w60ub:	blr			# get out when done

wait2ms:
	lis r31, 0x0001		# use r31 to send va
	ori r31, r31, 0x9000	#
	mtctr r31		# to counter reg
w2msa:	bdz w2msb		# branch out when done
	b w2msa			# not done - try again
w2msb:	blr			# get out when done

#********************************************************************
# function putcmd (print out an instruction)
#
# registers used
# r30 - pointer to LCD GPIO
# r29 - actually used by called timing routines for delay
# r28 - save return address
# r27 - sane LSBs of command for second transfer of 4 bits
# r26 - temp
#
# passed parameter:
# r6 - bit pattern for command to be sent
# return parameter:
# None
#********************************************************************

putcmd:	stmw r24, 0x180(r3)	# context switch
	mflr r28		# save the value of the LR in r28
	andi. r27, r6, 0xf	# store in r27 the least significant bits of r4
	srwi r26, r6, 4		# shift r4 4 bits to the right and store in r26
	andi. r26, r26, 0xf	# now, zero everything but 4 LSBs
	stw r26, 0(r14)		# send to LCD GPIO data lines
	bl wait100		# wait for 100 ns
	addi r26, r26, 0x40	# when 0x40 is added to the LCD register
	stw r26, 0(r14)		# the enable bit is set to '1'
	bl wait300		# wait for 300 ns
	subi r26, r26, 0x40	# when 0x40 is subtracted from the LCD register
	stw r26, 0(r14)		# the enable bit is set to '0'
	bl wait1500		# wait 1.5 us
	mr r26, r27		#
	stw r26, 0(r14)		# store the value of the r26 in the LCD register
	bl wait100		# wait 100 ns
	addi r26, r26, 0x40	# when 0x40 is added to the LCD register
	stw r26, 0(r14)		# the enable bit is set to '1'
	bl wait300		# wait for 300ns
	subi r26, r26, 0x40	# when 0x40 is subtracted from the LCD register
	stw r26, 0(r14)		# the enable bit is set to '0'
	bl wait60us		# wait 60us ( we only need 39us)
	mtlr r28		# write the value of r30 in LR
	lmw r24, 0x180(r3)	# context switch
	blr	

#********************************************************************
# function putc (print out a character)
#
# registers used
# r30 - pointer to LCD GPIO
# r29 - actually used by called timing routines for delay count
# r28 - save return address
# r27 - save LSBs of command for second transfer of 4 bits
# r26 - temp
# r25 - temp
#
# passed parameter:
# r6 - bit pattern for command to be sent
# return parameter:
# None
#********************************************************************

putc:   stmw r24, 0x1C0(r3)	# context switch
	mflr r28		# save the value of the LR in r28.
        andi. r27,r6,0xf	# store 4 LSB in R27
        srwi r26,r6,4		# shift r4 (input) right 4 bits, put in R26
        andi. r26,r26,0xf	# zero everything but 4 LSBs
        li r25,0x20		# 0x20 corresponds to 1 in RS bit position
        add r26,r26,r25		# R26 now has RS bit 1, 4 MSBs of data
        stw r26,0(r14)		# store to LCD GPIO reg
        bl wait100		# and wait...
        addi r26,r26,0x40	# now add 1 in E bit position
        stw r26,0(r14)		# and store it out
        bl wait300		# and wait...
        subi r26,r26,0x40	# this removes bit from E position
        stw r26,0(r14)		# and stor it out
        bl wait1500		# and wait...
        li r25,0x20		# again, 0x20 has 1 in RS bit position
        add r26,r25,r27		# so, add this to other half - stored in R27
        stw r26,0(r14)		# and send out to LCD GPIO reg
        bl wait100		# and wait...
        addi r26,r26,0x40	# add 1 in E bit position
        stw r26,0(r14)		# and send to LCD
        bl wait300		# and wait...
        subi r26,r26,0x40	# now, remove bit from E position
        stw r26,0(r14)		# and send it out
        bl wait60us		# and wait...
        mtlr r28		# copy the value of r28 to LR
	lmw r24, 0x1C0(r3)	# context switch
        blr			# and return
