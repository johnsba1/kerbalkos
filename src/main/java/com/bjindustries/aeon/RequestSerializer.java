package com.bjindustries.aeon;

import com.google.gson.Gson;
import org.apache.commons.beanutils.BeanUtils;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class RequestSerializer {

	public String createUpdate(Object update) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
		List<Field> fields = Arrays.asList(update.getClass().getDeclaredFields());
		Collections.sort(fields, (x,y) -> x.getName().compareTo(y.getName()));
		String request = "";
		for(Field f : fields){
			Annotation[] annotations = f.getDeclaredAnnotations();
			for(Annotation a : annotations){
				if(a.annotationType() == Expression.class){
					Expression e = (Expression) a;
					String exp = e.value();
					request += exp.replaceAll("\\$value", BeanUtils.getProperty(update, f.getName().replaceAll("_", ""))) + ".";
				}
			}
		}
		return request + "\nprint \"OK\".";
	}

	public String createRequest(Class<?> o){

		List<Field> fields = Arrays.asList(o.getDeclaredFields());
		Collections.sort(fields, (x,y) -> x.getName().compareTo(y.getName()));
		String request = "print \"[\" + ";
		boolean first = true;
		for(Field f : fields){
			Annotation[] annotations = f.getDeclaredAnnotations();
			for(Annotation a : annotations){
				if(a.annotationType() == Expression.class){
					Expression e = (Expression) a;
					String exp = e.value();

					if(!first){
						request += " + \",\" + ";
					}
					request += exp;
					first = false;
				}
			}
		}
		request += "+ \"]\".";
		return request;
	}

	public <T> T fromRequest(Class<T> clazz, String request) throws IllegalAccessException, InstantiationException, InvocationTargetException {
		System.out.println("Parsing: " + request);
		T obj = clazz.newInstance();

		Gson g  = new Gson();
		List response = g.fromJson(request, List.class);
		List<Field> fields = Arrays.asList(clazz.getDeclaredFields());
		Collections.sort(fields, (x,y) -> x.getName().compareTo(y.getName()));
		int currentIdx = 0;
		for(Field f : fields){
			Annotation[] annotations = f.getDeclaredAnnotations();
			for(Annotation a : annotations){
				if(a.annotationType() == Expression.class){
					Object o = response.get(currentIdx);
					BeanUtils.setProperty(obj, f.getName().replaceAll("_", ""), o);
					currentIdx++;
				}
			}
		}
		return obj;
	}

	public String createEvent(Class<?> clazz) {

		Annotation[] annotations = clazz.getDeclaredAnnotations();

		for(Annotation a : annotations){
			if(a.annotationType() == Expression.class){
				return ((Expression)a).value();
			}
		}
		return "";
	}
}
