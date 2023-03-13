(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (not (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}"))))
; ^([1-9]|1[0-2]|0[1-9]){1}(:[0-5][0-9][ ][aApP][mM]){1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9")))) ((_ re.loop 1 1) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re " ") (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")))) (str.to_re "\u{0a}"))))
; User-Agent\x3AUser-Agent\x3Awp-includes\x2Ftheme\x2Ephp\x3Fframe_ver2
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:wp-includes/theme.php?frame_ver2\u{0a}")))
(check-sat)
