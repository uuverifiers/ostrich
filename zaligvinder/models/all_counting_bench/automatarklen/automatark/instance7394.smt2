(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Z][a-z]+
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}")))))
; /\/bin\.exe$/U
(assert (str.in_re X (str.to_re "//bin.exe/U\u{0a}")))
; ^([07][1-7]|1[0-6]|2[0-7]|[35][0-9]|[468][0-8]|9[0-589])-?\d{7}$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "7")) (re.range "1" "7")) (re.++ (str.to_re "1") (re.range "0" "6")) (re.++ (str.to_re "2") (re.range "0" "7")) (re.++ (re.union (str.to_re "3") (str.to_re "5")) (re.range "0" "9")) (re.++ (re.union (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.range "0" "8")) (re.++ (str.to_re "9") (re.union (re.range "0" "5") (str.to_re "8") (str.to_re "9")))) (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\d+Host\x3A.*communitytipHost\x3AGirafaClient
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "communitytipHost:GirafaClient\u{13}\u{0a}"))))
; /\u{3d}\u{3d}$/P
(assert (str.in_re X (str.to_re "/==/P\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
