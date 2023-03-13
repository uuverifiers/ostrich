(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 666Host\u{3a}WEBCAM-Host\u{3a}
(assert (str.in_re X (str.to_re "666Host:WEBCAM-Host:\u{0a}")))
; Spy\-Locked\s+ExploiterSchwindler\x2Fr\x2Fkeys\x2Fkeys
(assert (str.in_re X (re.++ (str.to_re "Spy-Locked") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ExploiterSchwindler/r/keys/keys\u{0a}"))))
; ^([987]{1})(\d{1})(\d{8})
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "9") (str.to_re "8") (str.to_re "7"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^\/\d\u{2e}exe/Ui
(assert (str.in_re X (re.++ (str.to_re "//") (re.range "0" "9") (str.to_re ".exe/Ui\u{0a}"))))
; (\[[Ii][Mm][Gg]\])(\S+?)(\[\/[Ii][Mm][Gg]\])
(assert (not (str.in_re X (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}[") (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "M") (str.to_re "m")) (re.union (str.to_re "G") (str.to_re "g")) (str.to_re "][/") (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "M") (str.to_re "m")) (re.union (str.to_re "G") (str.to_re "g")) (str.to_re "]")))))
(check-sat)
