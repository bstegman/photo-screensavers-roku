'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.resolution = UI_Resolution()
    m.buffer = 60

    m.lineTop = m.top.findNode("lineTop")
    m.lineTop.width = m.resolution.width

    m.lineBottom = m.top.findNode("lineBottom")
    m.lineBottom.width = m.resolution.width
    m.lineBottom.translation = [0, m.resolution.height - m.lineBottom.height]

    m.paddleLeft = m.top.findNode("paddleLeft")
    m.paddleRight = m.top.findNode("paddleRight")

    m.ball = m.top.findNode("ball")
    UI_Screen_PlaceNodeCenter(m.ball)

    m.animationPaddle = m.top.findNode("animationPaddle")
    m.animationBall = m.top.findNode("animationBall")

    m.interpPaddle = m.top.findNode("interpPaddle") 
    m.interpBall = m.top.findNode("interpBall") 

    m.center = UI_Node_Center(m.ball)
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub __onScreenWillShow()

    m.animationBall.ObserveFieldScoped("state", "onAnimation")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub __onScreenWillHide()
End Sub

'-------------------------------------------------------------------------------
' __isActive
'-------------------------------------------------------------------------------
Sub __isActive(refresh=false as Boolean)

    moveBall()
End Sub

'-------------------------------------------------------------------------------
' onAnimation
'-------------------------------------------------------------------------------
Function onAnimation(evt as Object)

	status = evt.getData()
	if status = "stopped"

        moveBall()
	end if
End Function

'-------------------------------------------------------------------------------
' moveBall
'-------------------------------------------------------------------------------
Sub moveBall()

    if m.ball.translation[0] <= m.center.x

        ' ball
        ballX = m.paddleRight.translation[0] - m.ball.width
        ballTranslation = [ballX, MATH_Random(60, m.resolution.height - m.buffer)]
        m.interpBall.keyValue = [ m.ball.translation, ballTranslation ]

        ' paddle
        y = MATH_Random(ballTranslation[1], (ballTranslation[1] - m.paddleRight.height))
        if y <= m.buffer

            y = m.buffer + 10
        else if y + m.paddleRight.height >= m.resolution.height - m.buffer

            y = m.resolution.height - m.paddleRight.height - m.buffer
        end if
        goToTranslation = [m.paddleRight.translation[0], y]
        m.interpPaddle.keyValue = [ m.paddleRight.translation, goToTranslation]
        m.interpPaddle.fieldToInterp = "paddleRight.translation"

        ' animations
        m.animationPaddle.control = "start"
        m.animationBall.control = "start"
    else

        ' ball
        ballX = m.paddleLeft.translation[0] + m.ball.width
        ballTranslation = [ballX, MATH_Random(60, m.resolution.height - m.buffer)]
        m.interpBall.keyValue = [ m.ball.translation, ballTranslation ]

        ' paddle
        y = MATH_Random(ballTranslation[1], (ballTranslation[1] - m.paddleLeft.height))
        if y <= m.buffer

            y = m.buffer + 10
        else if y + m.paddleLeft.height >= m.resolution.height - m.buffer

            y = m.resolution.height - m.paddleLeft.height - m.buffer
        end if
        goToTranslation = [m.paddleLeft.translation[0], y]
        m.interpPaddle.keyValue = [ m.paddleLeft.translation, goToTranslation]
        m.interpPaddle.fieldToInterp = "paddleLeft.translation"

        ' animations
        m.animationPaddle.control = "start"
        m.animationBall.control = "start"
    end if
End Sub
