CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C Create a Grid of Hexahedron Centered at 0,0,0
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
       SUBROUTINE CreateGrid( IDIM, JDIM, KDIM, XYZ, ICONN )
       INTEGER IDIM, JDIM, KDIM
       REAL*8  XYZ
       DIMENSION XYZ( 3, IDIM, JDIM, KDIM )
       INTEGER ICONN
       DIMENSION ICONN ( 8, ( IDIM - 1 ) * ( JDIM - 1 ) * ( KDIM - 1 ))
       INTEGER I, J, K, IDX
       REAL*8  X, Y, Z, DX, DY, DZ
C       Print *, 'Size = ', IDIM, JDIM, KDIM
       PRINT *, 'Initialze Problem'
C XYZ Values of Nodes
C  From -1 to 1
       DX = 2.0 / ( IDIM - 1 )
       DY = 2.0 / ( JDIM - 1 )
       DZ = 2.0 / ( KDIM - 1 )
       Z = -1.0
       DO 112 K= 1, KDIM
       Y = -1.0
       DO 111 J= 1, JDIM
       X = -1.0
       DO 110 I= 1, IDIM
       XYZ( 1, I, J, K ) = X
       XYZ( 2, I, J, K ) = Y
       XYZ( 3, I, J, K ) = Z
       X =  X + DX
110     CONTINUE
       Y =  Y + DY
111     CONTINUE
       Z =  Z + DZ
112     CONTINUE
C Connections
       IDX = 1
       DO 122 K= 0, KDIM - 2
       DO 121 J= 0, JDIM - 2
       DO 120 I= 1, IDIM - 1
       ICONN( 1, IDX ) = ( K * JDIM * IDIM ) + ( J * IDIM ) + I
       ICONN( 2, IDX ) = ( K * JDIM * IDIM ) + ( J * IDIM ) + I + 1
       ICONN( 3, IDX ) = ( ( K + 1 )  * JDIM * IDIM ) + ( J * IDIM ) + I + 1
       ICONN( 4, IDX ) = ( ( K + 1 )  * JDIM * IDIM ) + ( J * IDIM ) + I
       ICONN( 5, IDX ) = ( K * JDIM * IDIM ) + ( ( J + 1 ) * IDIM ) + I
       ICONN( 6, IDX ) = ( K * JDIM * IDIM ) + ( ( J + 1 )  * IDIM ) + I + 1
       ICONN( 7, IDX ) = ( ( K + 1 )  * JDIM * IDIM ) +
    C          ( ( J + 1 ) * IDIM ) + I + 1
       ICONN( 8, IDX ) = ( ( K + 1 )  * JDIM * IDIM ) +
    C          ( ( J + 1 ) * IDIM ) + I
       IDX = IDX + 1
120     CONTINUE
121     CONTINUE
122     CONTINUE
       RETURN
       END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C Create a Node Centered Solution Field
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
       SUBROUTINE NodeData( IDIM, JDIM, KDIM, XYZ, NCVALUES)
       INTEGER IDIM, JDIM, KDIM
       REAL*8  XYZ
       DIMENSION XYZ( 3, IDIM, JDIM, KDIM )
       REAL*8 NCVALUES
       DIMENSION NCVALUES( IDIM, JDIM, KDIM )
       INTEGER I, J, K
       REAL*8 X, Y, Z
       PRINT *, 'Calculating Node Centered Data'
       DO 212, K=1, KDIM
       DO 211, J=1, JDIM
       DO 210, I=1, IDIM
               X = XYZ( 1, I, J, K )
               Y = XYZ( 2, I, J, K )
               Z = XYZ( 3, I, J, K )
               NCVALUES( I, J, K ) = SQRT( ( X * X ) + ( Y * Y ) + ( Z * Z ))
210     CONTINUE
211     CONTINUE
212     CONTINUE
       RETURN
       END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C Create a Cell Centered Solution Field
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
       SUBROUTINE CellData( IDIM, JDIM, KDIM, ITER, KICKER, XYZ, CCVALUES)
       INTEGER IDIM, JDIM, KDIM, ITER, KICKER
       REAL*8  XYZ
       DIMENSION XYZ( 3, IDIM, JDIM, KDIM )
       REAL*8 CCVALUES
       DIMENSION CCVALUES( IDIM - 1, JDIM - 1, KDIM - 1 )
       INTEGER I, J, K
       PRINT *, 'Calculating Cell Centered Data for Iteration ', ITER
       DO 312, K=1, KDIM - 1
       DO 311, J=1, JDIM - 1
       DO 310, I=1, IDIM - 1
               X = XYZ( 1, I, J, K )
               CCVALUES( I, J, K ) =
    C                  SIN( ( ( X + 1 ) * IDIM * KICKER ) / 3 * ITER ) /
    C                          EXP( X / ( 1.0 * ITER )  )
310     CONTINUE
311     CONTINUE
312     CONTINUE
C  Waste Time
       DO 313 I=1, 1000000
               X = 0.1 * ITER / I
               Y = SQRT( X * X )
               Z = EXP( Y )
313     CONTINUE
       RETURN
       END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C Main Program :
C       Initialize Grid
C       Initialize Node Centered Data
C       For Iteration = 1 to 10
C               Generate Cell Centered Data
C       Done
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
       PROGRAM HexMesh
       PARAMETER ( IDIM = 11 )
       PARAMETER ( JDIM = 13 )
       PARAMETER ( KDIM = 15 )
       REAL*8  XYZ
       DIMENSION XYZ( 3, IDIM, JDIM, KDIM )
       REAL*8  NCVALUES
       DIMENSION NCVALUES( IDIM, JDIM, KDIM )
C
       REAL*8  CCVALUES
       DIMENSION CCVALUES( IDIM - 1, JDIM - 1, KDIM - 1 )
C
       INTEGER ICONN
       DIMENSION ICONN ( 8, ( IDIM - 1 ) * ( JDIM - 1 ) * ( KDIM - 1 ))
C
       INTEGER ITER, KICKER, NITER, NARG
       INTEGER IUNIT
       CHARACTER*80    ARGIN
C
       NARG = IARGC()
       IF( NARG .GE. 1 ) THEN
               CALL GETARG( 1, ARGIN )
               READ( ARGIN, '(I)') NITER
       ELSE
               NITER = 10
       ENDIF
       CALL CreateGrid ( IDIM, JDIM, KDIM, XYZ, ICONN )
       CALL NodeData( IDIM, JDIM, KDIM, XYZ, NCVALUES)
C
       IUNIT = 14
       OPEN( IUNIT, FILE='XYZ.dat', STATUS='unknown' )
       REWIND IUNIT
       WRITE ( IUNIT, * ) IDIM * JDIM * KDIM
       WRITE ( IUNIT, * ) XYZ
       CLOSE (  IUNIT )
C
       IUNIT = 14
       OPEN( IUNIT, FILE='CONN.dat', STATUS='unknown' )
       REWIND IUNIT
       WRITE ( IUNIT, * ) 'Hex', ( IDIM - 1 ) * ( JDIM - 1 ) * ( KDIM - 1 )
       WRITE ( IUNIT, * ) ICONN
       CLOSE (  IUNIT )
C
       IUNIT = 14
       OPEN( IUNIT, FILE='NodeValues.dat', STATUS='unknown' )
       REWIND IUNIT
       WRITE ( IUNIT, * ) NCVALUES
       CLOSE (  IUNIT )
C
       IUNIT = 14
       OPEN( IUNIT, FILE='CellValues.dat', STATUS='unknown' )
       REWIND IUNIT
C
       KICKER = NITER
       DO 1000 ITER = 1, NITER
               CALL CellData( IDIM, JDIM, KDIM, ITER, KICKER, XYZ, CCVALUES)
               WRITE ( IUNIT, * ) CCVALUES
1000    CONTINUE
       CLOSE (  IUNIT )
C
       END
