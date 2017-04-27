mainloop:       ;First frame
                jsr getcontrols
                jsr scrolllogic
                jsr menu
                jsr updatepanel

                lda gameon                      ;Don't add actors etc. in title
                beq mainloop_nogame
                jsr addactors
                jsr processhealth
                jsr findobject
                jsr processobject
mainloop_nogame:

                ;Latent/continuous script program
                ldx scriptf
                beq mainloop_nocontscript
                lda scriptep
                jsr execscript

mainloop_nocontscript:
                jsr drawactors
                jsr updateframe

                ;Second (interpolated) frame
                jsr moveactors                
                jsr scrolllogic
                jsr interpolateactors
                jsr updateframe
mainloop_nodoor:jmp mainloop

