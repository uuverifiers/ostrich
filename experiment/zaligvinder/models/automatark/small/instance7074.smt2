(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
; /gate\u{2e}php\u{3f}reg=[a-zA-Z]{15}/U
(assert (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/U\u{0a}"))))
; actionID=&url=&load_frameset=1&autologin=0&anchor_string=&server_key=imap&imapuser=(.*)&pass=(.*)&new_lang=pt_BR&select_view=imp
(assert (str.in_re X (re.++ (str.to_re "actionID=&url=&load_frameset=1&autologin=0&anchor_string=&server_key=imap&imapuser=") (re.* re.allchar) (str.to_re "&pass=") (re.* re.allchar) (str.to_re "&new_lang=pt_BR&select_view=imp\u{0a}"))))
(check-sat)
