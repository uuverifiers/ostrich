(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\_\_)(.+)(\_\_)
(assert (not (str.in_re X (re.++ (str.to_re "__") (re.+ re.allchar) (str.to_re "__\u{0a}")))))
; Spyware\s+ToolBar\s+User-Agent\x3AMM_RECO\x2EEXEToClientonAlert
(assert (not (str.in_re X (re.++ (str.to_re "Spyware") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ToolBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:MM_RECO.EXEToClientonAlert\u{0a}")))))
; /^\/cnt\.php\?id=\d+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//cnt.php?id=") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; track\s+community\d+4\u{2e}8\u{2e}4www\x2Emaxifiles\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "track") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "community") (re.+ (re.range "0" "9")) (str.to_re "4.8.4www.maxifiles.com\u{0a}"))))
; ^(0?\d|1[012])\/([012]?\d|3[01])\/(\d{2}|\d{4})$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2"))) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
