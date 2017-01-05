" Make DebChanglog functions available as commands

command! DebNewVersion            :call NewVersion()
command! DebAddEntry              :call AddEntry()
command! DebCloseBug              :call CloseBug()
command! DebDistUnstable          :call Distribution("unstable")
command! DebDistFrozen            :call Distribution("frozen")
command! DebDistStable            :call Distribution("stable")
command! DebDistFrozenStable      :call Distribution("frozen unstable")
command! DebStableUnstable        :call Distribution("stable unstable")
command! DebStableFrozen          :call Distribution("stable frozen")
command! DebStableFrozenUnstable  :call Distribution("stable frozen unstable")
command! DebUrgencyLow            :call Urgency("low")
command! DebUrgencyMedium         :call Urgency("medium")
command! DebUrgencyHigh           :call Urgency("high")
command! DebUnfinalise            :call Unfinalise()
command! DebFinalise              :call Finalise()

" }}}

" vim: set foldmethod=marker:
