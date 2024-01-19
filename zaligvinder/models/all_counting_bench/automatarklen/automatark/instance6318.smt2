(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; actionID=&url=&load_frameset=1&autologin=0&anchor_string=&server_key=imap&imapuser=(.*)&pass=(.*)&new_lang=pt_BR&select_view=imp
(assert (not (str.in_re X (re.++ (str.to_re "actionID=&url=&load_frameset=1&autologin=0&anchor_string=&server_key=imap&imapuser=") (re.* re.allchar) (str.to_re "&pass=") (re.* re.allchar) (str.to_re "&new_lang=pt_BR&select_view=imp\u{0a}")))))
; JMailReportgpstool\u{2e}globaladserver\u{2e}com
(assert (not (str.in_re X (str.to_re "JMailReportgpstool.globaladserver.com\u{0a}"))))
; ^[0-9]{4} {0,1}[A-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; /^Host\u{3a}\u{20}\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\r?\n/Hsmi
(assert (str.in_re X (re.++ (str.to_re "/Host: ") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}/Hsmi\u{0a}"))))
; ([+]?\d[ ]?[(]?\d{3}[)]?[ ]?\d{2,3}[- ]?\d{2}[- ]?\d{2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "+")) (re.range "0" "9") (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re " ")) ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 2 2) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
