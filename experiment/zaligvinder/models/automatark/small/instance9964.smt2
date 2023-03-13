(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/bin\.exe$/U
(assert (not (str.in_re X (str.to_re "//bin.exe/U\u{0a}"))))
; eveocczmthmmq\u{2f}omzl\d+Host\x3Aulmxct\u{2f}mqoyc
(assert (str.in_re X (re.++ (str.to_re "eveocczmthmmq/omzl") (re.+ (re.range "0" "9")) (str.to_re "Host:ulmxct/mqoyc\u{0a}"))))
; \({1}[0-9]{3}\){1}\-{1}[0-9]{3}\-{1}[0-9]{4}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ")")) ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /ps0=[A-F0-9]*&ps1=[A-F0-9]*&cs1=[A-F0-9]*&cs2=[A-F0-9]*&cs3=[A-F0-9]*/P
(assert (str.in_re X (re.++ (str.to_re "/ps0=") (re.* (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&ps1=") (re.* (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&cs1=") (re.* (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&cs2=") (re.* (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&cs3=") (re.* (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/P\u{0a}"))))
; \D
(assert (not (str.in_re X (re.++ (re.comp (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
