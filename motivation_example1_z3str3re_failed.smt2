;test regex .{94}

(declare-const X String)
(assert (str.in_re X ((_ re.loop 94 94) (re.diff re.allchar (str.to_re "\n")))))
(assert (< 100 (str.len X)))
(check-sat)
(get-model)
